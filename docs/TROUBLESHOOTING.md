# NexusOS Troubleshooting

## Boot Issues

### Won't boot after install
1. Boot from the USB live image
2. Chroot into the system:
   ```bash
   sudo mount /dev/sdXN /mnt
   sudo arch-chroot /mnt
   ```
3. Reinstall GRUB:
   ```bash
   grub-install --target=x86_64-efi --efi-directory=/boot/efi
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

### Black screen after GRUB
- Add `nomodeset` to kernel parameters:
  ```bash
  sudo nano /etc/default/grub
  # Add: GRUB_CMDLINE_LINUX_DEFAULT="quiet nomodeset"
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  ```
- Update graphics drivers:
  ```bash
  sudo pacman -S linux-firmware
  # NVIDIA: sudo pacman -S nvidia nvidia-dkms
  # AMD: built into kernel
  # Intel: sudo pacman -S mesa
  ```

### Stuck at boot logo
- Press Esc to see boot messages
- Boot with `systemd.unit=multi-user.target` for console mode

## Network Issues

### No WiFi
```bash
rfkill list
sudo rfkill unblock all
sudo systemctl restart NetworkManager
nmcli device wifi list
nmcli device wifi connect "SSID" password "password"
```

### Tor not working
```bash
systemctl status tor
journalctl -u tor -f
sudo systemctl restart tor
sudo systemctl reload tor
ss -tlnp | grep 9050
```

### DNS not resolving
```bash
sudo systemctl restart systemd-resolved
resolvectl status
sudo resolvectl flush-caches
```

## AI Assistant Issues

### AI not responding
```bash
systemctl --user status nexus-ai
journalctl --user -u nexus-ai -f
systemctl --user restart nexus-ai
curl http://127.0.0.1:5210/status
```

### Voice not working
```bash
arecord -l
arecord -d 3 test.wav
python3 -c "from vosk import Model; print('Vosk OK')"
ls /opt/nexusos/ai/models/
```

### LLM not working
```bash
systemctl status ollama
ollama list
ollama pull llama3.2
ollama run llama3.2 "Hello"
```

## Desktop Issues

### GNOME not starting
```bash
sudo systemctl status gdm
sudo systemctl restart gdm
```

### Wayland issues
```bash
sudo nano /etc/gdm/custom.conf
# Set: WaylandEnable=false
sudo systemctl restart gdm
```

## Package Issues

### pacman keyring error
```bash
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy archlinux-keyring
```

### Package conflict
```bash
sudo pacman -Syu --overwrite '*'
```

### AUR packages
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
yay -S package-name
```

## Disk Issues

### Btrfs filesystem errors
```bash
sudo btrfs filesystem check /dev/sdXN
sudo umount /dev/sdXN
sudo btrfs filesystem repair /dev/sdXN
```

### Disk full
```bash
df -h
sudo ncdu /
sudo pacman -Sc
sudo journalctl --vacuum-time=7d
sudo snapper delete number
```

## Recovery

### Reset to defaults
```bash
sudo /opt/nexusos/scripts/post-install.sh
```

### Full reset (factory reset)
```bash
sudo rm -rf /home/raj/.config/nexusos
sudo /opt/nexusos/privacy/harden.sh
sudo systemctl restart nexus-ai
```

### Live USB recovery
1. Boot from NexusOS USB
2. Mount your disk:
   ```bash
   sudo mount /dev/sdXN /mnt
   sudo arch-chroot /mnt
   ```
3. Fix the issue
4. Exit and reboot

## Getting Help

- [GitHub Issues](https://github.com/ksraj20009/nexusos/issues)
- [Arch Wiki](https://wiki.archlinux.org/)
- [Tor Project](https://support.torproject.org/)
- [GNOME Help](https://help.gnome.org/)