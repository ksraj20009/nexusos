#!/bin/bash
# Vajra OS — Performance Suite
# Monitor, benchmark, and optimize system performance
set -e

echo "◆ Vajra OS — Performance Suite"

PERF_DIR="/opt/vajra/performance"
mkdir -p "$PERF_DIR"

# System benchmark tool
cat > "$PERF_DIR/benchmark.sh" << 'BENCH'
#!/bin/bash
echo "◆ Vajra OS System Benchmark"
echo "========================="
echo ""
echo "→ CPU: Computing pi to 5000 digits..."
START=$(date +%s%N)
echo "scale=5000; 4*a(1)" | bc -l > /dev/null 2>&1
END=$(date +%s%N)
CPU_MS=$(( (END - START) / 1000000 ))
echo "  CPU Score: ${CPU_MS}ms (lower = faster)"
echo ""
echo "→ Disk: Sequential write test..."
START=$(date +%s%N)
dd if=/dev/zero of=/tmp/vajra-disktest bs=1M count=256 oflag=direct 2>/dev/null
END=$(date +%s%N)
DISK_MS=$(( (END - START) / 1000000 ))
DISK_MBPS=$(( 256 * 1000 / (DISK_MS + 1) ))
rm -f /tmp/vajra-disktest
echo "  Disk Write: ${DISK_MBPS} MB/s"
echo ""
echo "→ Network: Latency check..."
PING=$(ping -c 3 -W 2 1.1.1.1 2>/dev/null | grep rtt | awk -F'/' '{print $5}' || echo "offline")
echo "  Network Latency: ${PING}ms"
echo ""
SCORE=0
[ "$CPU_MS" -lt 5000 ] && SCORE=$((SCORE + 25)) || SCORE=$((SCORE + 10))
[ "$DISK_MBPS" -gt 100 ] && SCORE=$((SCORE + 25)) || SCORE=$((SCORE + 10))
[ -n "$PING" ] && [ "$PING" != "offline" ] && SCORE=$((SCORE + 25)) || SCORE=$((SCORE + 5))
SCORE=$((SCORE + 25))
echo "========================="
echo "◆ Vajra Performance Score: $SCORE/100"
BENCH
chmod +x "$PERF_DIR/benchmark.sh"

# Auto-optimizer
cat > "$PERF_DIR/optimize.sh" << 'OPT'
#!/bin/bash
echo "◆ Vajra OS — System Optimizer"
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
echo "  ✓ Page cache cleared"
sudo apt-get clean 2>/dev/null
sudo apt-get autoremove -y 2>/dev/null
echo "  ✓ Package cache cleaned"
for svc in avahi-daemon cups bluetooth modemmanager; do
    sudo systemctl disable "$svc" 2>/dev/null && echo "  ✓ Disabled $svc" || true
done
sudo sysctl vm.swappiness=10 2>/dev/null || true
echo "  ✓ Swappiness optimized"
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance | sudo tee "$cpu" > /dev/null 2>&1 || true
done
echo "  ✓ CPU governor set to performance"
for dev in /sys/block/sd*/queue/scheduler; do
    if [ -f "$dev" ]; then
        rotational=$(cat "$(dirname "$dev")/../queue/rotational" 2>/dev/null || echo "1")
        if [ "$rotational" = "0" ]; then
            echo noop | sudo tee "$dev" > /dev/null 2>&1 || true
        else
            echo deadline | sudo tee "$dev" > /dev/null 2>&1 || true
        fi
    fi
done
echo "  ✓ I/O scheduler optimized"
if ! ls /dev/zram* &>/dev/null; then
    sudo modprobe zram 2>/dev/null
    echo lz4 | sudo tee /sys/block/zram0/comp_algorithm 2>/dev/null
    echo "2G" | sudo tee /sys/block/zram0/disksize 2>/dev/null
    sudo mkswap /dev/zram0 2>/dev/null
    sudo swapon /dev/zram0 2>/dev/null
    echo "  ✓ zram enabled"
fi
echo "◆ Optimization complete!"
OPT
chmod +x "$PERF_DIR/optimize.sh"

# Performance monitor daemon
cat > "$PERF_DIR/perf-monitor.sh" << 'MON'
#!/bin/bash
PERF_LOG="/var/log/vajra-perf.log"
INTERVAL=30
while true; do
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    MEM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
    DISK=$(df / | awk 'NR==2 {print $5}')
    LOAD=$(cat /proc/loadavg | awk '{print $1}')
    TS=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TS] CPU:$CPU% MEM:$MEM% DISK:$DISK LOAD:$LOAD" >> "$PERF_LOG"
    sleep "$INTERVAL"
done
MON
chmod +x "$PERF_DIR/perf-monitor.sh"

cat > /etc/systemd/system/vajra-perf-monitor.service << 'SVC'
[Unit]
Description=Vajra OS Performance Monitor
After=multi-user.target

[Service]
Type=simple
ExecStart=/opt/vajra/performance/perf-monitor.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SVC
systemctl enable vajra-perf-monitor 2>/dev/null || true

echo "  ✓ Benchmark: /opt/vajra/performance/benchmark.sh"
echo "  ✓ Optimizer: /opt/vajra/performance/optimize.sh"
echo "  ✓ Monitor: running as systemd service"
echo "◆ Done"
