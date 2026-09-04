#!/usr/bin/env python3
"""
NexusOS AI Assistant Engine v2.0
Full local AI: web search, OS control, voice, LLM, REST API.
Runs on localhost:5210. No cloud. No tracking.
"""

import os, sys, json, time, socket, subprocess, threading, urllib.request, urllib.parse, urllib.error
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime
from pathlib import Path

CONFIG = {
    "version": "2.0",
    "codename": "Aurora",
    "api_port": 5210,
    "api_host": "127.0.0.1",
    "voice_enabled": True,
    "voice_wake_word": "nexus",
    "privacy_mode": True,
    "log_file": "/var/log/nexus-ai.log",
    "max_context": 50,
    "user_name": "nexus",
    "local_llm": {
        "enabled": True,
        "model": "llama3.2",
        "endpoint": "http://127.0.0.1:11434/api/generate",
    },
}

def log(msg, level="INFO"):
    line = f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] [{level}] {msg}"
    print(line, flush=True)
    try:
        with open(CONFIG["log_file"], "a") as f:
            f.write(line + "\n")
    except:
        pass

class Context:
    def __init__(self, n=50):
        self.history, self.n = [], n
    def add(self, role, content):
        self.history.append({"role": role, "content": content, "ts": datetime.now().isoformat()})
        if len(self.history) > self.n:
            self.history = self.history[-self.n:]
    def recent(self, n=5):
        return self.history[-n:] if self.history else []
    def clear(self):
        self.history = []

ctx = Context()

class WebSearch:
    def search(self, query):
        try:
            params = urllib.parse.urlencode({"q": query, "format": "json", "no_html": "1"})
            url = f"https://api.duckduckgo.com/?{params}"
            req = urllib.request.Request(url, headers={"User-Agent": "NexusOS/2.0"})
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = json.loads(resp.read().decode("utf-8"))
            results = []
            if data.get("AbstractText"):
                results.append({"title": data.get("Heading", query), "content": data["AbstractText"], "url": data.get("AbstractURL", "")})
            for t in data.get("RelatedTopics", [])[:8]:
                if isinstance(t, dict) and t.get("Text"):
                    results.append({"title": t["Text"][:80], "content": t["Text"], "url": t.get("FirstURL", "")})
            if not results:
                r = self._wiki(query)
                if r:
                    results.append(r)
            return results or [{"title": "No results", "content": f"No instant answers for '{query}'."}]
        except Exception as e:
            return [{"title": "Error", "content": str(e)}]

    def _wiki(self, query):
        try:
            url = f"https://en.wikipedia.org/api/rest_v1/page/summary/{urllib.parse.quote(query.replace(' ', '_'))}"
            req = urllib.request.Request(url, headers={"User-Agent": "NexusOS/2.0"})
            with urllib.request.urlopen(req, timeout=10) as resp:
                data = json.loads(resp.read().decode("utf-8"))
            if data.get("extract"):
                return {"title": data.get("title", query), "content": data["extract"], "url": data.get("content_urls", {}).get("desktop", {}).get("page", "")}
        except:
            pass
        return None

    def alternatives(self, name):
        r1 = self.search(f"{name} alternative software")
        r2 = self.search(f"{name} open source alternative")
        seen, out = set(), []
        for r in r1 + r2:
            if r["title"] not in seen:
                seen.add(r["title"])
                out.append(r)
        return out[:10]

web = WebSearch()

class LLM:
    def __init__(self):
        self.enabled = CONFIG["local_llm"]["enabled"]
        self.endpoint = CONFIG["local_llm"]["endpoint"]
        self.model = CONFIG["local_llm"]["model"]

    def available(self):
        if not self.enabled:
            return False
        try:
            urllib.request.urlopen(self.endpoint.replace("/api/generate", "/api/tags"), timeout=2)
            return True
        except:
            return False

    def generate(self, prompt, context=""):
        if not self.available():
            return None
        try:
            p = f"{context}\n\nUser: {prompt}\nAssistant:" if context else f"User: {prompt}\nAssistant:"
            data = json.dumps({"model": self.model, "prompt": p, "stream": False, "options": {"temperature": 0.7}}).encode("utf-8")
            req = urllib.request.Request(self.endpoint, data=data, headers={"Content-Type": "application/json"}, method="POST")
            with urllib.request.urlopen(req, timeout=30) as resp:
                return json.loads(resp.read().decode("utf-8")).get("response", "").strip()
        except Exception as e:
            log(f"LLM error: {e}", "ERROR")
            return None

llm = LLM()

class OS:
    APPS = {
        "terminal": ["gnome-terminal", "xterm"],
        "browser": ["firefox-esr", "firefox", "chromium"],
        "tor": ["tor-browser"],
        "files": ["nautilus", "thunar"],
        "editor": ["gedit", "mousepad"],
        "calculator": ["gnome-calculator"],
        "settings": ["gnome-control-center"],
        "monitor": ["gnome-system-monitor", "htop"],
        "music": ["rhythmbox", "mpv"],
        "cleaner": ["bleachbit"],
    }

    def open_app(self, name):
        name = name.lower().strip()
        if name in self.APPS:
            for cmd in self.APPS[name]:
                if self._exists(cmd):
                    try:
                        subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, env={**os.environ, "DISPLAY": os.environ.get("DISPLAY", ":0")})
                        return True, f"Opened {name}"
                    except:
                        continue
        return False, f"App '{name}' not found. Available: {', '.join(self.APPS.keys())}"

    def run(self, cmd):
        try:
            r = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=30)
            return True, (r.stdout.strip() or r.stderr.strip() or "Done")
        except subprocess.TimeoutExpired:
            return False, "Timed out"
        except Exception as e:
            return False, str(e)

    def info(self):
        info = {"os": "NexusOS", "version": CONFIG["version"], "kernel": os.uname().release, "hostname": socket.gethostname(), "arch": os.uname().machine, "cpu": os.cpu_count(), "time": datetime.now().isoformat()}
        try:
            with open("/proc/uptime") as f:
                up = float(f.read().split()[0])
                info["uptime"] = f"{int(up//3600)}h {int((up%3600)//60)}m"
        except:
            pass
        return info

    def _exists(self, cmd):
        try:
            return subprocess.run(["which", cmd], capture_output=True, timeout=5).returncode == 0
        except:
            return False

os_ctl = OS()

class Processor:
    def __init__(self):
        self.boot = time.time()

    def process(self, query, user="nexus"):
        query = query.strip()
        if not query:
            return {"response": "What can I help with?", "action": "none"}
        q = query.lower()
        ctx.add("user", query)
        resp, action = None, "none"

        if q.startswith(("open ", "launch ", "start ")):
            app = q.replace("open ", "").replace("launch ", "").replace("start ", "").strip()
            _, resp = os_ctl.open_app(app)
            action = "open"
        elif q.startswith("run "):
            _, resp = os_ctl.run(query[4:].strip())
            action = "run"
        elif any(x in q for x in ["what time", "current time"]):
            resp = f"It's {datetime.now().strftime('%I:%M %p')} on {datetime.now().strftime('%A, %B %d, %Y')}."
        elif any(x in q for x in ["what date", "what day", "today"]):
            resp = f"Today is {datetime.now().strftime('%A, %B %d, %Y')}."
        elif any(x in q for x in ["system status", "system info", "about"]):
            i = os_ctl.info()
            resp = f"NexusOS {i['version']} '{CONFIG['codename']}'\nKernel: {i['kernel']}\nArch: {i['arch']}\nUptime: {i.get('uptime', '?')}\nCPU: {i['cpu']} cores"
        elif q.startswith("search ") or q.startswith("search the web for ") or q.startswith("search web for "):
            sq = query
            for p in ["search the web for ", "search web for ", "search "]:
                if q.startswith(p):
                    sq = query[len(p):]
                    break
            results = web.search(sq)
            lines = [f"Results for '{sq}':", ""]
            for i, r in enumerate(results[:5], 1):
                lines.append(f"{i}. {r['title']}")
                lines.append(f"   {r['content'][:200]}")
                if r.get("url"):
                    lines.append(f"   {r['url']}")
                lines.append("")
            resp = "\n".join(lines)
            action = "search"
        elif "alternative" in q:
            for p in ["alternatives for ", "alternatives to ", "alternative for ", "alternative to "]:
                if p in q:
                    sw = query[q.lower().index(p) + len(p):].strip().rstrip("?.").strip()
                    break
            else:
                sw = query.replace("alternative", "").strip()
            results = web.alternatives(sw)
            lines = [f"Alternatives for {sw}:", ""]
            for i, r in enumerate(results[:8], 1):
                lines.append(f"{i}. {r['title']}")
                lines.append("")
            resp = "\n".join(lines)
            action = "alternatives"
        elif q in ("help", "what can you do", "commands"):
            resp = ("Nexus AI Commands:\n\n"
                    "🔍 Search: 'search for AI news'\n"
                    "🔄 Alternatives: 'alternatives for Notion'\n"
                    "📂 Open: 'open browser'\n"
                    "⚙️ Run: 'run df -h'\n"
                    "📊 System: 'system status'\n"
                    "🕐 Time: 'what time is it?'\n"
                    "🔒 Lock: 'lock screen'\n\n"
                    "Voice: Say 'Nexus' then your command\n"
                    "API: POST to http://127.0.0.1:5210/query")
        elif q in ("hello", "hi", "hey", "namaste"):
            resp = f"Hello {user}! I'm Nexus AI. Type 'help' to see what I can do."
        elif "who are you" in q:
            resp = "I'm Nexus AI, the built-in assistant of NexusOS. I run locally for maximum privacy."
        elif "lock" in q and "screen" in q:
            os_ctl.run("loginctl lock-session 2>/dev/null || gnome-screensaver-command -l 2>/dev/null || true")
            resp = "Locking screen..."
        else:
            if llm.available():
                r = ctx.recent(5)
                c = " ".join([f"{m['role']}: {m['content']}" for m in r[:-1]])
                lr = llm.generate(query, c)
                if lr:
                    resp = lr
                    action = "llm"
            if not resp:
                results = web.search(query)
                lines = [f"Results for '{query}':", ""]
                for i, r in enumerate(results[:5], 1):
                    lines.append(f"{i}. {r['title']}")
                    lines.append(f"   {r['content'][:200]}")
                    lines.append("")
                resp = "\n".join(lines)
                action = "search"

        ctx.add("assistant", resp)
        return {"response": resp, "action": action, "query": query, "timestamp": datetime.now().isoformat()}

proc = Processor()

class Voice:
    def __init__(self):
        self.enabled = CONFIG["voice_enabled"]
        self.word = CONFIG["voice_wake_word"]
        self.listening = False

    def init(self):
        if not self.enabled:
            return False
        try:
            from vosk import Model, KaldiRecognizer
            import sounddevice as sd
            path = "/opt/nexusos/ai/models/vosk-model-small-en-in-0.4"
            if not os.path.exists(path):
                return False
            self.model = Model(path)
            self.rec = KaldiRecognizer(self.model, 16000)
            return True
        except:
            return False

    def loop(self):
        if not self.init():
            return
        import sounddevice as sd, json as jm
        self.listening = True
        log("Voice listening started (wake word: 'nexus')", "INFO")
        def cb(indata, frames, ti, status):
            if self.rec.AcceptWaveform(bytes(indata)):
                r = jm.loads(self.rec.Result())
                t = r.get("text", "").strip().lower()
                if t and self.word in t:
                    cmd = t.split(self.word, 1)[-1].strip()
                    if cmd:
                        log(f"Voice: '{cmd}'", "INFO")
                        proc.process(cmd)
        try:
            with sd.RawInputStream(samplerate=16000, blocksize=8000, dtype="int16", channels=1, callback=cb):
                while self.listening:
                    time.sleep(0.1)
        except Exception as e:
            log(f"Voice error: {e}", "ERROR")

    def stop(self):
        self.listening = False

voice = Voice()

class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _json(self, data, code=200):
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data, indent=2, ensure_ascii=False).encode("utf-8"))

    def do_GET(self):
        if self.path == "/status":
            i = os_ctl.info()
            i["ai_version"] = CONFIG["version"]
            i["voice"] = voice.listening
            i["llm"] = llm.available()
            self._json({"status": "ok", "data": i})
        elif self.path == "/history":
            self._json({"status": "ok", "data": ctx.recent(20)})
        elif self.path == "/help":
            self._json({"status": "ok", "data": proc.process("help")["response"]})
        else:
            self._json({"error": "Not found"}, 404)

    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0))).decode("utf-8")
        try:
            data = json.loads(body) if body else {}
        except:
            self._json({"error": "Invalid JSON"}, 400)
            return
        if self.path == "/query":
            q = data.get("query", "")
            if not q:
                self._json({"error": "Missing 'query'"}, 400)
                return
            self._json({"status": "ok", "data": proc.process(q, data.get("user", "nexus"))})
        elif self.path == "/voice/start":
            if not voice.listening:
                threading.Thread(target=voice.loop, daemon=True).start()
            self._json({"status": "ok", "msg": "Voice started"})
        elif self.path == "/voice/stop":
            voice.stop()
            self._json({"status": "ok", "msg": "Voice stopped"})
        elif self.path == "/context/clear":
            ctx.clear()
            self._json({"status": "ok", "msg": "Cleared"})
        else:
            self._json({"error": "Not found"}, 404)

def cli():
    print(f"\n  ◆ Nexus AI v{CONFIG['version']} '{CONFIG['codename']}'\n")
    print("  Type 'help' for commands, 'exit' to quit.\n")
    while True:
        try:
            q = input("\033[36mnexus@nexusos:~$ \033[0m").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nGoodbye!")
            break
        if not q:
            continue
        if q.lower() in ("exit", "quit", "bye"):
            break
        r = proc.process(q)
        print(f"\n{r['response']}")

def main():
    log(f"Nexus AI v{CONFIG['version']} starting...", "INFO")
    if "--service" in sys.argv or "--daemon" in sys.argv:
        if CONFIG["voice_enabled"]:
            threading.Thread(target=voice.loop, daemon=True).start()
        try:
            HTTPServer((CONFIG["api_host"], CONFIG["api_port"]), Handler).serve_forever()
        except KeyboardInterrupt:
            log("Shutting down...", "INFO")
    else:
        cli()

if __name__ == "__main__":
    main()
