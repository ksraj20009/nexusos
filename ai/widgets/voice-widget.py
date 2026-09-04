#!/usr/bin/env python3
"""
Vajra OS — Voice Widget (GTK)
Floating voice control bar for desktop.
Shows Buddhi status, voice button, AI response.
"""
import gi, os, subprocess, json, urllib.request
gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
from gi.repository import Gtk, Gdk, GLib, GObject

class VajraVoiceWidget(Gtk.Window):
    def __init__(self):
        super().__init__(title="Buddhi Voice")
        self.set_default_size(400, 60)
        self.set_type_hint(Gdk.WindowTypeHint.DOCK)
        self.set_keep_above(True)
        self.set_decorated(False)
        self.move(460, 20)

        self.is_listening = False
        self.api = "http://127.0.0.1:5210"

        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        box.set_margin_top(8)
        box.set_margin_bottom(8)
        box.set_margin_start(12)
        box.set_margin_end(12)
        self.add(box)

        self.label = Gtk.Label(label="Buddhi")
        self.label.set_hexpand(True)
        box.pack_start(self.label, True, True, 0)

        self.btn = Gtk.Button(label="Voice")
        self.btn.connect("clicked", self.on_voice_clicked)
        box.pack_start(self.btn, False, False, 0)

        self.status_btn = Gtk.Button(label="Status")
        self.status_btn.connect("clicked", self.on_status_clicked)
        box.pack_start(self.status_btn, False, False, 0)

        css = b"""
        window { background: #1a1a2e; border-radius: 10px; }
        label { color: #e0e0e0; font-size: 14px; }
        button { background: #c8500c; color: white; border-radius: 6px; padding: 4px 12px; }
        button:hover { background: #e06010; }
        """
        provider = Gtk.CssProvider()
        provider.load_from_data(css)
        screen = Gdk.Screen.get_default()
        Gtk.StyleContext.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

        self.show_all()
        GLib.timeout_add_seconds(2, self.update_status)

    def on_voice_clicked(self, widget):
        self.toggle_voice(not self.is_listening)

    def toggle_voice(self, on):
        endpoint = "/voice/start" if on else "/voice/stop"
        try:
            req = urllib.request.Request(self.api + endpoint, data=b"{}", headers={"Content-Type": "application/json"}, method="POST")
            urllib.request.urlopen(req, timeout=3)
            self.is_listening = on
            self.label.set_label("Listening..." if on else "Buddhi")
            self.btn.set_label("Stop" if on else "Voice")
        except Exception as e:
            self.label.set_label(f"Error: {e}")

    def on_status_clicked(self, widget):
        try:
            with urllib.request.urlopen(self.api + "/status", timeout=3) as resp:
                data = json.loads(resp.read().decode())
                d = data.get("data", {})
                msg = f"Vajra OS {d.get('ai_version', '?')}\nKernel: {d.get('kernel', '?')}\nVoice: {'ON' if d.get('voice_listening') else 'OFF'}\nLLM: {'ON' if d.get('llm_available') else 'OFF'}"
                dialog = Gtk.MessageDialog(self, 0, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "Vajra OS Status")
                dialog.format_secondary_text(msg)
                dialog.run()
                dialog.destroy()
        except Exception as e:
            self.label.set_label(f"Error: {e}")

    def update_status(self):
        try:
            with urllib.request.urlopen(self.api + "/status", timeout=2) as resp:
                data = json.loads(resp.read().decode())
                d = data.get("data", {})
                voice = d.get("voice_listening", False)
                self.is_listening = voice
                self.label.set_label("Listening..." if voice else "Buddhi")
                self.btn.set_label("Stop" if voice else "Voice")
        except:
            self.label.set_label("Buddhi (offline)")
        return True

def main():
    win = VajraVoiceWidget()
    Gtk.main()

if __name__ == "__main__":
    main()
