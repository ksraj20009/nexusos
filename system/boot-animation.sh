#!/bin/bash
# Vajra OS — Boot Animation System
# Custom Plymouth-style boot animation with Vajra branding
set -e

VAJRA_BOOT_DIR="/usr/share/vajra-boot"
PLYMOUTH_THEME_DIR="/usr/share/plymouth/themes/vajra"

echo "◆ Vajra OS Boot Animation Setup"

# Create boot animation directory
mkdir -p "$VAJRA_BOOT_DIR"

# Create animated boot script
cat > "$VAJRA_BOOT_DIR/boot-animation.sh" << 'ANIM'
#!/bin/bash
# Vajra boot animation — runs during early boot
VAJRA_LOGO="
   ██╗   ██╗ █████╗ ██████╗ ███████╗██╗  ██╗
   ██║   ██║██╔══██╗██╔══██╗██╔════╝██║  ██║
   ██║   ██║███████║██████╔╝███████╗███████║
   ╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║██╔══██║
    ╚████╔╝ ██║  ██║██║  ██║███████║██║  ██║
     ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
        वज्र OS  —  Thunderbolt of Indra
"
clear
echo -e "\033[36m$VAJRA_LOGO\033[0m"
echo ""
for i in $(seq 1 20); do
    pct=$((i * 5))
    bar=$(printf '#%.0s' $(seq 1 $i))
    printf "\r  \033[32m[%-20s] %3d%%\033[0m" "$bar" "$pct"
    sleep 0.1
done
echo ""
echo ""
echo "  \033[36m◆ Welcome to Vajra OS\033[0m"
sleep 1
clear
ANIM
chmod +x "$VAJRA_BOOT_DIR/boot-animation.sh"

# Create Plymouth theme (if Plymouth available)
if command -v plymouth-set-default-theme &>/dev/null; then
    mkdir -p "$PLYMOUTH_THEME_DIR"
    cat > "$PLYMOUTH_THEME_DIR/vajra.plymouth" << 'PLY'
[Plymouth Theme]
Name=Vajra
Description=Vajra OS Boot Theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/vajra
ScriptFile=/usr/share/plymouth/themes/vajra/vajra.script
PLY

    cat > "$PLYMOUTH_THEME_DIR/vajra.script" << 'SCR'
# Vajra Plymouth Script — Animated thunderbolt
screen_width = Window.GetWidth();
screen_height = Window.GetHeight();
logo_image = Image.Text("वज्र OS", 1.0, 0.8, 0.2);
logo_sprite = Sprite(logo_image);
logo_sprite.SetX(screen_width / 2 - logo_image.GetWidth() / 2);
logo_sprite.SetY(screen_height / 2 - logo_image.GetHeight() / 2);
progress = 0;

fun refresh() {
    progress += 0.02;
    if (progress > 1) progress = 0;
    bar_width = progress * 300;
    bar = Image.New(bar_width, 4, 0.8, 0.6, 0.2);
    bar_sprite = Sprite(bar);
    bar_sprite.SetX(screen_width / 2 - 150);
    bar_sprite.SetY(screen_height / 2 + 50);
}

Plymouth.SetRefreshFunction(refresh);
SCR

    plymouth-set-default-theme vajra -R 2>/dev/null || true
    echo "  ✓ Plymouth boot theme installed"
else
    echo "  ℹ Plymouth not found — using console boot animation"
fi

# Install systemd service for console animation
cat > /etc/systemd/system/vajra-boot.service << 'SVC'
[Unit]
Description=Vajra OS Boot Animation
DefaultDependencies=no
After=local-fs.target
Before=basic.target

[Service]
Type=oneshot
ExecStart=/usr/share/vajra-boot/boot-animation.sh
StandardOutput=tty
TTYPath=/dev/tty1
RemainAfterExit=yes

[Install]
WantedBy=sysinit.target
SVC

systemctl enable vajra-boot.service 2>/dev/null || true
echo "  ✓ Boot animation installed"
echo "◆ Done"
