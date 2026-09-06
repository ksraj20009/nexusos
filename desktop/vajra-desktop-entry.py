#!/usr/bin/env python3
"""
Vajra OS Desktop Entry Generator
Creates .desktop files for all Vajra OS applications.
"""

import os

APPS_DIR = "/usr/share/applications"

APP_ENTRIES = [
    {"filename":"vajra-welcome.desktop","name":"Welcome to Vajra OS","comment":"Get started","exec":"bash /opt/vajra/scripts/welcome.sh","icon":"vajra-os","categories":"System;GTK;","terminal":"true"},
    {"filename":"vajra-installer.desktop","name":"Install Vajra OS","comment":"Install to hard drive","exec":"sudo python3 /opt/vajra/system/vajra-installer.py","icon":"vajra-os","categories":"System;GTK;","terminal":"true"},
    {"filename":"vajra-settings.desktop","name":"Vajra Settings","comment":"Configure Vajra OS","exec":"bash /opt/vajra/settings/settings-launcher.sh","icon":"vajra-settings","categories":"Settings;System;GTK;","terminal":"false"},
    {"filename":"vajra-mode-switch.desktop","name":"Switch Mode","comment":"Beginner / Pro mode","exec":"bash /opt/vajra/desktop/mode-switcher.sh","icon":"system-switch-user","categories":"System;GTK;","terminal":"true"},
    {"filename":"buddhi-ai.desktop","name":"Buddhi AI","comment":"Your AI assistant","exec":"python3 /opt/vajra/ai/buddhi-ai.py","icon":"buddhi-ai","categories":"System;Utility;AI;","terminal":"true"},
    {"filename":"buddhi-voice.desktop","name":"Buddhi Voice","comment":"Voice control","exec":"python3 /opt/vajra/ai/widgets/voice-widget.py","icon":"audio-input-microphone","categories":"Utility;Accessibility;","terminal":"false"},
    {"filename":"vajra-vedic-calculator.desktop","name":"Vedic Calculator","comment":"Vedic math shortcuts","exec":"python3 /opt/vajra/ai/vedic-calculator.py","icon":"vajra-calculator","categories":"Education;Math;GTK;","terminal":"true"},
    {"filename":"vajra-terminal.desktop","name":"Vajra Terminal","comment":"Command line","exec":"gnome-terminal -- bash /opt/vajra/apps/vajra-terminal.sh","icon":"vajra-terminal","categories":"System;TerminalEmulator;GTK;","terminal":"false"},
    {"filename":"vajra-calculator.desktop","name":"Calculator","comment":"Vajra OS Calculator","exec":"python3 /opt/vajra/apps/vajra-calculator.py","icon":"vajra-calculator","categories":"Utility;Math;GTK;","terminal":"true"},
    {"filename":"vajra-text-editor.desktop","name":"Text Editor","comment":"Vajra OS Text Editor","exec":"python3 /opt/vajra/apps/vajra-text-editor.py","icon":"accessories-text-editor","categories":"Utility;TextEditor;GTK;","terminal":"true"},
    {"filename":"vajra-file-manager.desktop","name":"File Manager","comment":"Vajra OS File Manager","exec":"bash /opt/vajra/apps/vajra-file-manager.sh","icon":"vajra-files","categories":"System;FileManager;GTK;","terminal":"true"},
    {"filename":"vajra-image-viewer.desktop","name":"Image Viewer","comment":"View images","exec":"bash /opt/vajra/apps/vajra-image-viewer.sh","icon":"image-viewer","categories":"Graphics;Viewer;GTK;","terminal":"true"},
    {"filename":"vajra-calendar.desktop","name":"Calendar","comment":"Calendar with Indian festivals","exec":"python3 /opt/vajra/apps/vajra-calendar.py","icon":"vajra-calendar","categories":"Office;Calendar;GTK;","terminal":"true"},
    {"filename":"vajra-weather.desktop","name":"Weather","comment":"Weather forecast","exec":"python3 /opt/vajra/apps/vajra-weather.py","icon":"vajra-weather","categories":"Utility;GTK;","terminal":"true"},
    {"filename":"vajra-notes.desktop","name":"Notes","comment":"Quick notes","exec":"python3 /opt/vajra/apps/vajra-notes.py","icon":"accessories-text-editor","categories":"Utility;TextEditor;GTK;","terminal":"true"},
    {"filename":"vajra-music-player.desktop","name":"Music Player","comment":"Play music","exec":"bash /opt/vajra/apps/vajra-music-player.sh","icon":"vajra-music","categories":"AudioVideo;Audio;Player;GTK;","terminal":"true"},
    {"filename":"vajra-system-monitor.desktop","name":"System Monitor","comment":"Monitor resources","exec":"python3 /opt/vajra/apps/vajra-system-monitor.py","icon":"utilities-system-monitor","categories":"System;Monitor;GTK;","terminal":"true"},
    {"filename":"vajra-app-store.desktop","name":"App Store","comment":"Install applications","exec":"bash /opt/vajra/apps/app-store.sh","icon":"vajra-app-store","categories":"System;PackageManager;GTK;","terminal":"true"},
    {"filename":"vajra-code-playground.desktop","name":"Code Playground","comment":"Write and run code","exec":"python3 /opt/vajra/apps/code-playground.py","icon":"text-x-script","categories":"Development;IDE;GTK;","terminal":"true"},
    {"filename":"vajra-pdf-toolkit.desktop","name":"PDF Toolkit","comment":"Merge, split, edit PDFs","exec":"bash /opt/vajra/apps/pdf-toolkit.sh","icon":"application-pdf","categories":"Office;GTK;","terminal":"true"},
    {"filename":"vajra-spotlight-search.desktop","name":"Spotlight Search","comment":"Search everything","exec":"bash /opt/vajra/desktop/spotlight-search.sh","icon":"system-search","categories":"Utility;GTK;","terminal":"true"},
    {"filename":"vajra-task-manager.desktop","name":"Task Manager","comment":"Manage processes","exec":"bash /opt/vajra/desktop/task-manager.sh","icon":"utilities-system-monitor","categories":"System;Monitor;GTK;","terminal":"true"},
    {"filename":"vajra-screenshot.desktop","name":"Screenshot","comment":"Capture screen","exec":"gnome-screenshot --interactive","icon":"camera-photo","categories":"Utility;Graphics;GTK;","terminal":"false"},
    {"filename":"vajra-control-center.desktop","name":"Control Center","comment":"Quick controls","exec":"bash /opt/vajra/desktop/control-center.sh","icon":"preferences-system","categories":"System;Settings;GTK;","terminal":"true"},
    {"filename":"vajra-clipboard-manager.desktop","name":"Clipboard Manager","comment":"Clipboard history","exec":"bash /opt/vajra/desktop/clipboard-manager.sh","icon":"edit-paste","categories":"Utility;GTK;","terminal":"true"},
    {"filename":"vajra-color-picker.desktop","name":"Color Picker","comment":"Pick colors","exec":"bash /opt/vajra/desktop/color-picker.sh","icon":"gtk-color-picker","categories":"Graphics;Utility;GTK;","terminal":"true"},
    {"filename":"vajra-screen-recorder.desktop","name":"Screen Recorder","comment":"Record screen","exec":"bash /opt/vajra/system/screen-recorder.sh","icon":"media-record","categories":"Graphics;Recorder;GTK;","terminal":"true"},
    {"filename":"vajra-update-manager.desktop","name":"Update Manager","comment":"Install updates","exec":"bash /opt/vajra/system/update-manager.sh","icon":"system-software-update","categories":"System;Settings;GTK;","terminal":"true"},
    {"filename":"vajra-backup-manager.desktop","name":"Backup Manager","comment":"Backup and restore","exec":"bash /opt/vajra/system/backup-manager.sh","icon":"document-save","categories":"System;Settings;GTK;","terminal":"true"},
    {"filename":"vajra-troubleshooter.desktop","name":"Troubleshooter","comment":"Fix common problems","exec":"bash /opt/vajra/system/vajra-troubleshooter.sh","icon":"system-help","categories":"System;Diagnostics;GTK;","terminal":"true"},
    {"filename":"vajra-migration-helper.desktop","name":"Migration Helper","comment":"Move data from Windows/Mac","exec":"bash /opt/vajra/system/vajra-migration-helper.sh","icon":"system-software-install","categories":"System;GTK;","terminal":"true"},
    {"filename":"vajra-security-suite.desktop","name":"Security Suite","comment":"Cybersecurity tools","exec":"bash /opt/vajra/security/security-suite.sh","icon":"vajra-security","categories":"System;Security;GTK;","terminal":"true"},
    {"filename":"vajra-cyber-academy.desktop","name":"Cyber Academy","comment":"Learn ethical hacking","exec":"bash /opt/vajra/security/cyber-academy.sh","icon":"system-search","categories":"Education;Security;GTK;","terminal":"true"},
    {"filename":"vajra-privacy-dashboard.desktop","name":"Privacy Dashboard","comment":"Privacy settings","exec":"bash /opt/vajra/privacy/privacy-dashboard.sh","icon":"security-high","categories":"Settings;Security;GTK;","terminal":"true"},
    {"filename":"vajra-tor-decision.desktop","name":"Tor Decision Center","comment":"Learn about Tor","exec":"bash /opt/vajra/privacy/tor-decision-center.sh","icon":"network-server","categories":"Network;Security;GTK;","terminal":"true"},
    {"filename":"vajra-night-light.desktop","name":"Night Light","comment":"Blue light filter","exec":"bash /opt/vajra/desktop/night-light.sh","icon":"weather-clear-night","categories":"Utility;Accessibility;GTK;","terminal":"true"},
    {"filename":"vajra-font-manager.desktop","name":"Font Manager","comment":"Manage fonts","exec":"bash /opt/vajra/system/font-manager.sh","icon":"preferences-desktop-font","categories":"Settings;Desktop;GTK;","terminal":"true"},
    {"filename":"vajra-power-manager.desktop","name":"Power Manager","comment":"Power settings","exec":"bash /opt/vajra/system/power-manager.sh","icon":"battery","categories":"Settings;Hardware;GTK;","terminal":"true"},
    {"filename":"vajra-bluetooth.desktop","name":"Bluetooth Manager","comment":"Connect devices","exec":"bash /opt/vajra/network/bluetooth-suite.sh","icon":"bluetooth","categories":"Network;Settings;GTK;","terminal":"true"},
    {"filename":"vajra-printer-suite.desktop","name":"Printer Manager","comment":"Configure printers","exec":"bash /opt/vajra/system/printer-suite.sh","icon":"printer","categories":"Settings;Hardware;GTK;","terminal":"true"},
    {"filename":"vajra-gaming-suite.desktop","name":"Gaming Suite","comment":"Game mode, Steam, emulators","exec":"bash /opt/vajra/gaming/gaming-suite.sh","icon":"input-gaming","categories":"Game;Utility;GTK;","terminal":"true"},
]

def generate_desktop_file(entry):
    lines = [
        "[Desktop Entry]",
        f"Name={entry['name']}",
        f"Comment={entry['comment']}",
        f"Exec={entry['exec']}",
        f"Icon={entry['icon']}",
        f"Categories={entry['categories']}",
        f"Terminal={entry.get('terminal','false')}",
        "Type=Application",
        "StartupNotify=true",
    ]
    return "\n".join(lines) + "\n"

def main():
    os.makedirs(APPS_DIR, exist_ok=True)
    print(f"=== Vajra OS Desktop Entry Generator ===")
    print(f"Output: {APPS_DIR}")
    print(f"Entries: {len(APP_ENTRIES)}\n")
    for entry in APP_ENTRIES:
        filepath = os.path.join(APPS_DIR, entry["filename"])
        with open(filepath, "w") as f:
            f.write(generate_desktop_file(entry))
        print(f"  + {entry['filename']}")
    print(f"\n[+] Generated {len(APP_ENTRIES)} desktop entries")
    try:
        os.system("update-desktop-database -q 2>/dev/null &")
    except Exception:
        pass
    print("[+] Desktop database updated")

if __name__ == "__main__":
    main()