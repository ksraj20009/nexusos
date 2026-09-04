#!/usr/bin/env python3
"""
Vajra OS — Buddhi Log Analyzer
Parses system logs and surfaces anomalies using pattern matching.
"""
import os, re, subprocess
from datetime import datetime, timedelta
from collections import Counter

CRITICAL_PATTERNS = [
    (r"segfault", "Segmentation fault detected"),
    (r"oom-kill|out of memory", "Out of memory kill"),
    (r"kernel panic", "Kernel panic"),
    (r"authentication failure|Failed password", "Authentication failure"),
    (r"break-in attempt|POSSIBLE BREAK-IN", "SSH break-in attempt"),
    (r"disk full|No space left", "Disk full"),
    (r"SMART error|disk failure", "Disk failure warning"),
    (r"overcurrent", "USB overcurrent"),
    (r"thermal|temperature", "Thermal warning"),
    (r"firmware bug", "Firmware bug"),
    (r"ACPI.*error", "ACPI error"),
    (r"dropped.*packet", "Network packet drops"),
]

WARNING_PATTERNS = [
    (r"warning", "Generic warning"),
    (r"deprecated", "Deprecated feature"),
    (r"timeout|timed out", "Timeout occurred"),
    (r"connection refused|connection reset", "Network connection issue"),
    (r"permission denied", "Permission denied"),
    (r"failed to", "Something failed"),
]

def analyze(journal_minutes=60):
    since = (datetime.now() - timedelta(minutes=journal_minutes)).strftime("%Y-%m-%d %H:%M:%S")
    try:
        result = subprocess.run(
            ["journalctl", "--since", since, "--no-pager", "--no-hostname"],
            capture_output=True, text=True, timeout=30
        )
        logs = result.stdout
    except:
        try:
            with open("/var/log/syslog") as f:
                logs = f.read()[-50000:]
        except:
            return "Could not read system logs."

    critical = []
    warnings = []
    for pattern, description in CRITICAL_PATTERNS:
        matches = re.findall(pattern, logs, re.IGNORECASE)
        if matches:
            critical.append((description, len(matches)))
    for pattern, description in WARNING_PATTERNS:
        matches = re.findall(pattern, logs, re.IGNORECASE)
        if matches:
            warnings.append((description, len(matches)))

    error_sources = Counter()
    for line in logs.split("\n"):
        if "error" in line.lower() or "fail" in line.lower():
            parts = line.split()
            if len(parts) > 4:
                source = parts[4] if "]" not in parts[4] else parts[5] if len(parts) > 5 else ""
                error_sources[source] += 1

    report = f"Buddhi Log Analyzer\nAnalyzing last {journal_minutes} minutes\nLog lines: {len(logs.splitlines())}\n\n"
    if critical:
        report += "CRITICAL ISSUES:\n"
        for desc, count in critical:
            report += f"  {desc} ({count}x)\n"
    else:
        report += "No critical issues found.\n"
    if warnings:
        report += f"\nWARNINGS ({len(warnings)}):\n"
        for desc, count in warnings[:10]:
            report += f"  {desc} ({count}x)\n"
    if error_sources:
        report += f"\nTop error sources:\n"
        for source, count in error_sources.most_common(5):
            report += f"  {source}: {count} errors\n"
    return report

if __name__ == "__main__":
    import sys
    minutes = int(sys.argv[1]) if len(sys.argv) > 1 else 60
    print(analyze(minutes))
