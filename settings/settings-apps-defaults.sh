#!/bin/bash
# Vajra OS — Apps & Default Apps Settings
set -e
echo "◆ Vajra OS — Apps & Defaults Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-apps-defaults.sh" << 'APPS'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Apps & Defaults"
        echo "  Default Browser: $(xdg-settings get default-web-browser 2>/dev/null || echo 'firefox-esr.desktop')"
        echo "  Default Mail: $(xdg-mime query default x-scheme-handler/mailto 2>/dev/null || echo 'thunderbird.desktop')"
        echo "  Default Terminal: $(update-alternatives --query x-terminal-emulator 2>/dev/null | grep Value | awk '{print $2}' || echo 'gnome-terminal')"
        echo "  Default Editor: $(update-alternatives --query editor 2>/dev/null | grep Value | awk '{print $2}' || echo 'nano')"
        echo "  Installed Packages: $(dpkg -l | grep '^ii' | wc -l)"
        echo "  Flatpaks: $(flatpak list 2>/dev/null | wc -l)"
        echo "  Snaps: $(snap list 2>/dev/null | wc -l)"
        echo "  Startup Apps:"
        ls ~/.config/autostart/*.desktop 2>/dev/null | while read -r f; do echo "    $(grep '^Name=' "$f" | cut -d= -f2)"; done
        ;;
    default-browser) xdg-settings set default-web-browser "${2:-firefox-esr.desktop}" 2>/dev/null; echo "  ✓ Default browser set to ${2:-firefox-esr.desktop}" ;;
    default-mail) xdg-mime default "${2:-thunderbird.desktop}" x-scheme-handler/mailto 2>/dev/null; echo "  ✓ Default mail set to ${2:-thunderbird.desktop}" ;;
    default-terminal) sudo update-alternatives --set x-terminal-emulator "/usr/bin/${2:-gnome-terminal}" 2>/dev/null; echo "  ✓ Default terminal set to ${2:-gnome-terminal}" ;;
    default-editor) sudo update-alternatives --set editor "/usr/bin/${2:-nano}" 2>/dev/null; echo "  ✓ Default editor set to ${2:-nano}" ;;
    file-type)
        EXT="$2"; APP="$3"
        [ -z "$EXT" ] || [ -z "$APP" ] && echo "  Usage: vajra-settings apps file-type <.ext> <app.desktop>" && exit 1
        MIME=$(xdg-mime query filetype "$EXT" 2>/dev/null || echo "application/octet-stream")
        xdg-mime default "$APP" "$MIME" 2>/dev/null; echo "  ✓ $EXT files now open with $APP"
        ;;
    startup) vajra-startup list ;;
    startup-add) vajra-startup add "$2" "$3" ;;
    startup-remove) vajra-startup remove "$2" ;;
    installed) dpkg -l | grep '^ii' | awk '{print "    "$2}' | head -30 ;;
    uninstall) sudo apt-get remove -y "$2" 2>/dev/null; echo "  ✓ $2 removed" ;;
    install) sudo apt-get install -y "$2" 2>/dev/null; echo "  ✓ $2 installed" ;;
    store) vajra-store ;;
    *) echo "Usage: vajra-settings apps {status|default-browser|default-mail|default-terminal|default-editor|file-type|startup|installed|install|uninstall|store}" ;;
esac
APPS
chmod +x "$SD_DIR/settings-apps-defaults.sh"
ln -sf "$SD_DIR/settings-apps-defaults.sh" /usr/local/bin/vajra-settings-apps 2>/dev/null || true
echo "  ✓ Apps & defaults settings installed"
echo "◆ Done"
