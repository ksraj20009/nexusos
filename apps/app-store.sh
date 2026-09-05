#!/bin/bash
# Vajra OS — App Store
# Curated app store with one-click install
set -e

echo "◆ Vajra OS — App Store Setup"

AS_DIR="/opt/vajra/appstore"
mkdir -p "$AS_DIR"

cat > "$AS_DIR/app-store.sh" << 'AS'
#!/bin/bash
install_app() {
    NAME="$1"; PKG="$2"; TYPE="${3:-apt}"
    echo "  Installing $NAME..."
    case "$TYPE" in
        apt) sudo apt-get install -y "$PKG" 2>/dev/null && echo "  ✓ $NAME installed" || echo "  ✗ Failed" ;;
        flatpak) flatpak install -y flathub "$PKG" 2>/dev/null && echo "  ✓ $NAME installed" || echo "  ✗ Failed" ;;
        snap) sudo snap install "$PKG" 2>/dev/null && echo "  ✓ $NAME installed" || echo "  ✗ Failed" ;;
    esac
}

show_categories() {
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  ◆ Vajra OS — App Store                       ║"
    echo "╠═══════════════════════════════════════════════╣"
    echo "║  1. Web Browsers    5. Development            ║"
    echo "║  2. Office          6. Communication          ║"
    echo "║  3. Media           7. Games                   ║"
    echo "║  4. Graphics        0. Exit                    ║"
    echo "╚═══════════════════════════════════════════════╝"
}

show_browsers() {
    echo "1. Firefox  2. Chromium  3. Brave  4. Tor Browser"
    read -p "Select: " c
    case "$c" in
        1) install_app "Firefox" "firefox-esr" apt ;;
        2) install_app "Chromium" "chromium" apt ;;
        3) install_app "Brave" "com.brave.Browser" flatpak ;;
        4) install_app "Tor" "tor-browser" apt ;;
    esac
}

show_office() {
    echo "1. LibreOffice  2. Thunderbird  3. GIMP  4. Inkscape  5. Calibre"
    read -p "Select: " c
    case "$c" in
        1) install_app "LibreOffice" "libreoffice" apt ;;
        2) install_app "Thunderbird" "thunderbird" apt ;;
        3) install_app "GIMP" "gimp" apt ;;
        4) install_app "Inkscape" "inkscape" apt ;;
        5) install_app "Calibre" "calibre" apt ;;
    esac
}

show_media() {
    echo "1. VLC  2. MPV  3. OBS Studio  4. Audacity  5. Kdenlive  6. Spotify"
    read -p "Select: " c
    case "$c" in
        1) install_app "VLC" "vlc" apt ;;
        2) install_app "MPV" "mpv" apt ;;
        3) install_app "OBS" "obs-studio" apt ;;
        4) install_app "Audacity" "audacity" apt ;;
        5) install_app "Kdenlive" "kdenlive" apt ;;
        6) install_app "Spotify" "spotify" snap ;;
    esac
}

show_dev() {
    echo "1. VS Code  2. Neovim  3. Docker  4. Git  5. Python  6. Node.js"
    read -p "Select: " c
    case "$c" in
        1) install_app "VS Code" "code" apt ;;
        2) install_app "Neovim" "neovim" apt ;;
        3) install_app "Docker" "docker.io" apt ;;
        4) install_app "Git" "git" apt ;;
        5) install_app "Python" "python3 python3-pip" apt ;;
        6) install_app "Node.js" "nodejs npm" apt ;;
    esac
}

show_comm() {
    echo "1. Discord  2. Telegram  3. Signal  4. Zoom"
    read -p "Select: " c
    case "$c" in
        1) install_app "Discord" "com.discordapp.Discord" flatpak ;;
        2) install_app "Telegram" "telegram-desktop" apt ;;
        3) install_app "Signal" "org.signal.Signal" flatpak ;;
        4) install_app "Zoom" "zoom" apt ;;
    esac
}

show_games() {
    echo "1. Steam  2. RetroArch  3. SuperTuxKart  4. 0 AD"
    read -p "Select: " c
    case "$c" in
        1) install_app "Steam" "steam" apt ;;
        2) install_app "RetroArch" "retroarch" apt ;;
        3) install_app "SuperTuxKart" "supertuxkart" apt ;;
        4) install_app "0 AD" "0ad" apt ;;
    esac
}

while true; do
    show_categories
    read -p "  Select [0-7]: " cat
    case "$cat" in
        1) show_browsers ;; 2) show_office ;; 3) show_media ;;
        4) install_app "GIMP" "gimp" apt ;; 5) show_dev ;;
        6) show_comm ;; 7) show_games ;;
        0) echo "Namaste!"; exit 0 ;;
        *) echo "  Invalid" ;;
    esac
    read -p "  Press Enter to continue..." _
    clear
done
AS
chmod +x "$AS_DIR/app-store.sh"
ln -sf "$AS_DIR/app-store.sh" /usr/local/bin/vajra-store 2>/dev/null || true

echo "  ✓ App store installed"
echo "  ◆ Usage: vajra-store"
echo "◆ Done"
