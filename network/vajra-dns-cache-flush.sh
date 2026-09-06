#!/bin/bash
# Vajra OS DNS Cache Flush
set -e
echo "=== Vajra OS DNS Cache Flush ==="
echo "[*] Flushing DNS cache..."
systemctl flush-dns 2>/dev/null && echo "[+] systemd-resolved cache flushed" || true
service nscd restart 2>/dev/null && echo "[+] nscd cache flushed" || true
service dnsmasq restart 2>/dev/null && echo "[+] dnsmasq cache flushed" || true
echo "[*] Note: Restart your browser to flush its DNS cache"
echo "[+] DNS cache flush complete"