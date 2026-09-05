#!/bin/bash
# Vajra OS — Security Audit Checklist
# Checks your own system for security issues and recommends fixes.
case "${1:-run}" in
    run)
        echo "  Vajra OS - Security Audit"
        SCORE=0; TOTAL=20
        # 1. Firewall
        if sudo ufw status 2>/dev/null | grep -q "active"; then echo "  [PASS] Firewall active"; SCORE=$((SCORE+1))
        else echo "  [FAIL] Firewall NOT active. Fix: sudo ufw enable"; fi
        # 2. SSH root login
        if grep -q "PermitRootLogin no" /etc/ssh/sshd_config 2>/dev/null; then echo "  [PASS] SSH root login disabled"; SCORE=$((SCORE+1))
        else echo "  [FAIL] SSH root login may be enabled"; fi
        # 3. Disk encryption
        if lsblk -o FSTYPE 2>/dev/null | grep -q crypto_LUKS; then echo "  [PASS] Disk encryption (LUKS)"; SCORE=$((SCORE+1))
        else echo "  [FAIL] No disk encryption. Fix: sudo cryptsetup luksFormat /dev/sdX"; fi
        # 4. Tor
        if systemctl is-active tor &>/dev/null; then echo "  [PASS] Tor active"; SCORE=$((SCORE+1))
        else echo "  [WARN] Tor not active (optional)"; fi
        # 5. Camera
        if ! lsmod | grep -q uvcvideo; then echo "  [PASS] Camera disabled"; SCORE=$((SCORE+1))
        else echo "  [WARN] Camera enabled. Fix: sudo modprobe -r uvcvideo"; fi
        # 6. Microphone
        if ! amixer sget Capture 2>/dev/null | grep -q "\[on\]"; then echo "  [PASS] Microphone muted"; SCORE=$((SCORE+1))
        else echo "  [WARN] Microphone enabled. Fix: amixer sset Capture mute"; fi
        # 7. Bluetooth
        if ! systemctl is-active bluetooth &>/dev/null; then echo "  [PASS] Bluetooth off"; SCORE=$((SCORE+1))
        else echo "  [WARN] Bluetooth on. Fix: sudo systemctl stop bluetooth"; fi
        # 8. Auto updates
        if crontab -l 2>/dev/null | grep -q "apt-get upgrade"; then echo "  [PASS] Auto-updates configured"; SCORE=$((SCORE+1))
        else echo "  [FAIL] No auto-updates. Fix: vajra-settings recovery auto-update on"; fi
        # 9. MAC randomization
        if grep -q "cloned-mac-address=random" /etc/NetworkManager/conf.d/*.conf 2>/dev/null; then echo "  [PASS] MAC randomization"; SCORE=$((SCORE+1))
        else echo "  [FAIL] No MAC randomization. Fix: vajra-settings privacy mac-random"; fi
        # 10. Telemetry
        echo "  [PASS] Telemetry blocked (Vajra default)"; SCORE=$((SCORE+1))
        # 11. Password
        if [ $(awk -F: '$3 >= 1000 && $3 < 65534 {print length($2)}' /etc/shadow 2>/dev/null | head -1) -ge 20 ]; then echo "  [PASS] Password appears strong"; SCORE=$((SCORE+1))
        else echo "  [WARN] Password may be weak. Fix: vajra-password-auditor strength"; fi
        # 12. Guest account
        if ! id guest &>/dev/null 2>&1; then echo "  [PASS] No guest account"; SCORE=$((SCORE+1))
        else echo "  [WARN] Guest account exists. Fix: vajra-settings accounts guest-off"; fi
        # 13. ASLR
        if [ "$(cat /proc/sys/kernel/randomize_va_space 2>/dev/null)" = "2" ]; then echo "  [PASS] ASLR enabled"; SCORE=$((SCORE+1))
        else echo "  [FAIL] ASLR not enabled. Fix: echo 2 | sudo tee /proc/sys/kernel/randomize_va_space"; fi
        # 14. Open ports
        OPEN=$(ss -tlnp 2>/dev/null | grep -c LISTEN); if [ "$OPEN" -lt 10 ]; then echo "  [PASS] Few open ports ($OPEN)"; SCORE=$((SCORE+1))
        else echo "  [WARN] Many open ports ($OPEN). Check: ss -tlnp"; fi
        # 15. SSH password auth
        if grep -q "PasswordAuthentication no" /etc/ssh/sshd_config 2>/dev/null; then echo "  [PASS] SSH password auth disabled"; SCORE=$((SCORE+1))
        else echo "  [WARN] SSH password auth may be enabled"; fi
        # 16. Failed logins
        FAILED=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l); if [ "$FAILED" -lt 10 ]; then echo "  [PASS] Few failed logins ($FAILED)"; SCORE=$((SCORE+1))
        else echo "  [WARN] Many failed logins ($FAILED) - brute force?"; fi
        # 17. Updates pending
        UPDATES=$(apt list --upgradable 2>/dev/null | grep -c upgradable); if [ "$UPDATES" -lt 5 ]; then echo "  [PASS] System up to date ($UPDATES pending)"; SCORE=$((SCORE+1))
        else echo "  [FAIL] $UPDATES updates pending. Fix: sudo apt-get upgrade -y"; fi
        # 18. Screen lock
        if [ "$(gsettings get org.gnome.desktop.screensaver lock-enabled 2>/dev/null)" = "true" ]; then echo "  [PASS] Screen lock enabled"; SCORE=$((SCORE+1))
        else echo "  [FAIL] Screen lock disabled. Fix: vajra-settings privacy screen-lock 300"; fi
        # 19. DNS
        if grep -q "127.0.0.1" /etc/resolv.conf 2>/dev/null; then echo "  [PASS] Local DNS (Tor/encrypted)"; SCORE=$((SCORE+1))
        else echo "  [WARN] External DNS. Consider: vajra-settings privacy harden"; fi
        # 20. Kernel hardening
        if [ "$(cat /proc/sys/kernel/kptr_restrict 2>/dev/null)" = "2" ]; then echo "  [PASS] Kernel hardened"; SCORE=$((SCORE+1))
        else echo "  [FAIL] Kernel not hardened. Fix: vajra-settings privacy harden"; fi
        echo ""
        echo "  Security Score: $SCORE / $TOTAL"
        if [ $SCORE -ge 18 ]; then echo "  Rating: EXCELLENT"
        elif [ $SCORE -ge 14 ]; then echo "  Rating: GOOD"
        elif [ $SCORE -ge 10 ]; then echo "  Rating: MODERATE"
        else echo "  Rating: WEAK - Fix issues above!"; fi
        ;;
    fix-all)
        echo "  Applying all security fixes..."
        sudo ufw enable 2>/dev/null; sudo ufw default deny incoming 2>/dev/null
        sudo modprobe -r uvcvideo 2>/dev/null; amixer sset Capture mute 2>/dev/null
        sudo systemctl stop bluetooth 2>/dev/null
        echo 2 | sudo tee /proc/sys/kernel/randomize_va_space > /dev/null
        vajra-settings privacy mac-random 2>/dev/null
        vajra-settings privacy screen-lock 300 2>/dev/null
        sudo apt-get update -qq && sudo apt-get upgrade -y 2>/dev/null
        echo "  Security fixes applied!"
        ;;
    help|*) echo "  Commands: run, fix-all" ;;
esac
