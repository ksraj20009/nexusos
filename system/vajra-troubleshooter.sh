#!/bin/bash
# Vajra OS — Troubleshooter
# Solves 23 real problems that people struggle with.
case "${1:-menu}" in
    menu)
        echo "  Vajra OS - Troubleshooter"
        echo "  Internet: [1]No internet [2]WiFi won't connect [3]Slow internet [4]Site blocked"
        echo "  Performance: [5]Slow PC [6]Disk full [7]High CPU [8]High memory"
        echo "  Apps: [9]App won't open [10]App crashes [11]Can't install [12]Update failed"
        echo "  Hardware: [13]Printer [14]No sound [15]Bluetooth [16]USB [17]Monitor"
        echo "  System: [18]Forgot password [19]Black screen [20]Won't update"
        echo "  Data: [21]Recover files [22]Backup [23]Transfer from Windows/Mac"
        read -p "  Problem number (1-23): " p
        case "$p" in
            1) vajra-troubleshooter no-internet ;;
            2) vajra-troubleshooter wifi ;;
            3) vajra-troubleshooter slow-internet ;;
            4) vajra-troubleshooter site-blocked ;;
            5) vajra-troubleshooter slow-pc ;;
            6) vajra-troubleshooter disk-full ;;
            7) vajra-troubleshooter high-cpu ;;
            8) vajra-troubleshooter high-memory ;;
            9) vajra-troubleshooter app-wont-open ;;
            10) vajra-troubleshooter app-crash ;;
            11) vajra-troubleshooter cant-install ;;
            12) vajra-troubleshooter update-fail ;;
            13) vajra-troubleshooter printer ;;
            14) vajra-troubleshooter no-sound ;;
            15) vajra-troubleshooter bluetooth ;;
            16) vajra-troubleshooter usb ;;
            17) vajra-troubleshooter monitor ;;
            18) vajra-troubleshooter forgot-password ;;
            19) vajra-troubleshooter black-screen ;;
            20) vajra-troubleshooter wont-update ;;
            21) vajra-troubleshooter recover-files ;;
            22) vajra-troubleshooter backup ;;
            23) vajra-troubleshooter transfer ;;
        esac
        ;;
    no-internet)
        echo "  Fix: Internet Not Working"
        echo "  1. Check interface: ip link show"
        echo "  2. Restart network: sudo systemctl restart NetworkManager"
        echo "  3. Check DNS: ping -c 3 8.8.8.8"
        echo "  4. If Tor is on, try: vajra-tor-decision off"
        echo "  5. Set DNS: echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf"
        ;;
    wifi)
        echo "  Fix: WiFi Not Connecting"
        echo "  1. Check WiFi: nmcli radio wifi (if off: nmcli radio wifi on)"
        echo "  2. List networks: nmcli device wifi list"
        echo "  3. Connect: vajra-settings network wifi-connect SSID PASSWORD"
        echo "  4. Restart WiFi: nmcli radio wifi off; sleep 2; nmcli radio wifi on"
        echo "  5. Check driver: lspci | grep -i network"
        ;;
    slow-internet)
        echo "  Fix: Slow Internet"
        echo "  1. Test speed: speedtest-cli"
        echo "  2. Check if Tor is slowing you: systemctl is-active tor"
        echo "  3. Check background downloads: ps aux | grep -E 'apt|wget|torrent'"
        echo "  4. Change DNS: vajra-settings network dns 1.1.1.1"
        echo "  5. Check WiFi signal: nmcli -f SSID,SIGNAL device wifi list"
        ;;
    site-blocked)
        echo "  Fix: Cannot Access a Website"
        echo "  1. Check if site is down: ping -c 3 <website>"
        echo "  2. Change DNS: vajra-settings network dns 1.1.1.1"
        echo "  3. Flush DNS: sudo systemd-resolve --flush-caches"
        echo "  4. Use Tor: vajra-tor-decision menu"
        ;;
    slow-pc)
        echo "  Fix: Computer Is Slow"
        echo "  1. Top CPU users: ps aux --sort=-%cpu | head -10"
        echo "  2. Top memory: ps aux --sort=-%mem | head -10"
        echo "  3. Disk space: df -h /"
        echo "  4. Clean up: vajra-settings recovery clean"
        echo "  5. Check startup apps: vajra-startup list"
        echo "  6. Kill heavy process: kill <PID>"
        ;;
    disk-full)
        echo "  Fix: Low Disk Space"
        echo "  1. Check disk: df -h"
        echo "  2. Find large files: sudo find / -type f -size +100M"
        echo "  3. Clean cache: sudo apt-get clean && sudo apt-get autoremove -y"
        echo "  4. Clean temp: rm -rf /tmp/vajra-* ~/.cache/thumbnails"
        echo "  5. Clean logs: sudo journalctl --vacuum-size=100M"
        echo "  6. Smart cleanup: vajra-cleanup clean"
        ;;
    high-cpu)
        echo "  Fix: High CPU Usage"
        echo "  Top CPU consumers:"
        ps aux --sort=-%cpu | head -10
        echo "  Kill process: kill <PID> (or kill -9 <PID> to force)"
        ;;
    high-memory)
        echo "  Fix: High Memory Usage"
        echo "  Top memory consumers:"
        ps aux --sort=-%mem | head -10
        echo "  Free: free -h"
        echo "  Clear cache: sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches"
        ;;
    app-wont-open)
        echo "  Fix: App Won't Open"
        echo "  1. Launch from terminal to see errors: <app-name>"
        echo "  2. Reinstall: vajra-download remove <app> && vajra-download install <app>"
        echo "  3. Check deps: ldd /usr/bin/<app> | grep 'not found'"
        echo "  4. Fix deps: sudo apt-get install -f"
        echo "  5. Reset config: rm -rf ~/.config/<app>"
        ;;
    app-crash)
        echo "  Fix: App Keeps Crashing"
        echo "  1. Check logs: journalctl -u <app> | tail -20"
        echo "  2. Clear cache: rm -rf ~/.cache/<app>"
        echo "  3. Update: sudo apt-get update && sudo apt-get upgrade <app>"
        echo "  4. Check disk space: df -h"
        ;;
    cant-install)
        echo "  Fix: Cannot Install Software"
        echo "  1. Update: sudo apt-get update"
        echo "  2. Fix broken: sudo apt-get --fix-broken install"
        echo "  3. Fix dpkg: sudo dpkg --configure -a"
        echo "  4. Search: apt-cache search <package>"
        echo "  5. Check disk space: df -h"
        ;;
    update-fail)
        echo "  Fix: Software Update Failed"
        echo "  1. Clear cache: sudo apt-get clean && sudo apt-get update"
        echo "  2. Fix broken: sudo apt-get -f install"
        echo "  3. Try: sudo apt-get upgrade -y"
        ;;
    printer)
        echo "  Fix: Printer Not Working"
        echo "  1. Check: lpstat -t"
        echo "  2. Restart CUPS: sudo systemctl restart cups"
        echo "  3. Install drivers: sudo apt-get install system-config-printer"
        echo "  4. Test: echo 'Test' | lp"
        ;;
    no-sound)
        echo "  Fix: Sound Not Working"
        echo "  1. Unmute: amixer sset Master unmute && amixer sset Master 50%"
        echo "  2. Check devices: aplay -l"
        echo "  3. Restart audio: pulseaudio -k && pulseaudio --start"
        echo "  4. Select output: vajra-settings sound output-device <device>"
        ;;
    bluetooth)
        echo "  Fix: Bluetooth Not Connecting"
        echo "  1. Start Bluetooth: sudo systemctl start bluetooth"
        echo "  2. Scan: bluetoothctl scan on"
        echo "  3. Pair: bluetoothctl pair <MAC>"
        echo "  4. Connect: bluetoothctl connect <MAC>"
        ;;
    usb)
        echo "  Fix: USB Drive Not Detected"
        echo "  1. List USB: lsusb"
        echo "  2. Check drives: lsblk"
        echo "  3. Mount: sudo mount /dev/sdX1 /mnt"
        echo "  4. Check errors: dmesg | tail -20"
        ;;
    monitor)
        echo "  Fix: External Monitor Not Detected"
        echo "  1. Check displays: xrandr"
        echo "  2. Enable: xrandr --output <display-name> --auto"
        echo "  3. Arrange: vajra-settings display arrange"
        ;;
    forgot-password)
        echo "  Fix: Forgot Password"
        echo "  1. Reboot, press 'e' at boot menu"
        echo "  2. Add 'init=/bin/bash' to linux line"
        echo "  3. Ctrl+X to boot"
        echo "  4. mount -o remount,rw /"
        echo "  5. passwd <username>"
        echo "  6. reboot -f"
        ;;
    black-screen)
        echo "  Fix: Black Screen On Boot"
        echo "  1. Switch to TTY: Ctrl+Alt+F2 (or F3, F4)"
        echo "  2. Login"
        echo "  3. Restart display: sudo systemctl restart gdm3"
        echo "  4. Reinstall graphics: sudo apt-get install --reinstall xserver-xorg"
        echo "  5. Boot to Recovery Mode"
        ;;
    wont-update)
        echo "  Fix: System Won't Update"
        echo "  1. Remove locks: sudo rm -f /var/lib/dpkg/lock*"
        echo "  2. Fix dpkg: sudo dpkg --configure -a"
        echo "  3. Clear cache: sudo apt-get clean && sudo apt-get update"
        echo "  4. Update: sudo apt-get upgrade -y"
        ;;
    recover-files)
        echo "  Fix: Recover Deleted Files"
        echo "  IMPORTANT: Stop using the disk immediately!"
        echo "  1. Use photorec: sudo photorec /dev/sdX"
        echo "  2. Use foremost: vajra-forensics file-carve /dev/sdX /tmp/recovered"
        echo "  3. Check trash: ls ~/.local/share/Trash/files/"
        ;;
    backup) echo "  Back up: vajra-backup home" ;;
    transfer) echo "  Transfer: vajra-migration-helper menu" ;;
    help|*) echo "  Run: vajra-troubleshooter menu" ;;
esac
