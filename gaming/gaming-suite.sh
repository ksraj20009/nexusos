#!/bin/bash
# Vajra OS — Gaming & Media Suite
set -e
echo "◆ Vajra OS Gaming & Media Suite"

cat > /usr/local/bin/vajra-gaming << 'VG'
#!/bin/bash
case "$1" in
    install)
        echo "Installing Steam + Proton..."
        sudo dpkg --add-architecture i386 2>/dev/null || true
        sudo apt-get update
        sudo apt-get install -y steam steam-devices mesa-vulkan-drivers libgl1-mesa-dri:i386 2>/dev/null || true
        echo "✓ Steam installed. Enable Proton in Steam > Settings > Compatibility"
        ;;
    retro)
        echo "Installing RetroArch..."
        sudo apt-get install -y retroarch 2>/dev/null || snap install retroarch 2>/dev/null || true
        echo "✓ RetroArch installed. ROMs: ~/RetroArch/roms/"
        ;;
    media-server)
        echo "Installing Jellyfin media server..."
        sudo apt-get install -y gnupg curl 2>/dev/null || true
        curl -fsSL https://repo.jellyfin.org/install-debuntu.sh | sudo bash 2>/dev/null || true
        sudo apt-get install -y jellyfin 2>/dev/null || true
        sudo systemctl enable jellyfin 2>/dev/null || true
        sudo systemctl start jellyfin 2>/dev/null || true
        echo "✓ Jellyfin at http://localhost:8096"
        ;;
    audio)
        echo "Installing audio production tools..."
        sudo apt-get install -y ardour lmms audacity 2>/dev/null || true
        echo "✓ Ardour (DAW), LMMS (beats), Audacity (editor)"
        ;;
    video)
        echo "Installing video tools..."
        sudo apt-get install -y kdenlive obs-studio 2>/dev/null || true
        echo "✓ Kdenlive (editor), OBS Studio (streaming)"
        ;;
    photo)
        echo "Installing photo tools..."
        sudo apt-get install -y gimp darktable rawtherapee 2>/dev/null || true
        echo "✓ GIMP, Darktable, RawTherapee"
        ;;
    all) "$0" install; "$0" retro; "$0" media-server; "$0" audio; "$0" video; "$0" photo ;;
    *) echo "Usage: vajra-gaming [install|retro|media-server|audio|video|photo|all]" ;;
esac
VG
chmod +x /usr/local/bin/vajra-gaming

echo "◆ Gaming & Media Suite installed!"
echo "  vajra-gaming install     — Steam + Proton"
echo "  vajra-gaming retro       — RetroArch"
echo "  vajra-gaming media-server — Jellyfin"
echo "  vajra-gaming audio       — Ardour, LMMS, Audacity"
echo "  vajra-gaming video       — Kdenlive, OBS"
echo "  vajra-gaming photo       — GIMP, Darktable"
echo "  vajra-gaming all         — Everything"
