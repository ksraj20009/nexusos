#!/bin/bash
# Vajra OS — Task Manager
# Process viewer and killer like Windows Task Manager
set -e

echo "◆ Vajra OS — Task Manager Setup"

TM_DIR="/opt/vajra/taskmanager"
mkdir -p "$TM_DIR"

cat > "$TM_DIR/task-manager.sh" << 'TM'
#!/bin/bash
# Vajra OS Task Manager

case "${1:-list}" in
    list|top)
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║  ◆ Vajra OS — Task Manager                                      ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║  PID    CPU%   MEM%    USER         COMMAND                     ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        ps aux --sort=-%cpu | head -20 | awk 'NR>1 {
            cpu=$3; mem=$4; pid=$2; user=$1; cmd=substr($11, 1, 30)
            printf "  %-6s %-6s %-6s %-12s %-28s\n", pid, cpu"%", mem"%", user, cmd
        }'
        echo "╚══════════════════════════════════════════════════════════════════╝"
        echo ""
        echo "  Total processes: $(ps aux | wc -l)"
        echo "  CPU usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
        echo "  Memory: $(free -h | awk '/Mem:/ {print $3 "/" $2}')"
        ;;
    kill)
        PID="$2"
        if [ -z "$PID" ]; then
            echo "  Usage: vajra-task kill <PID>"
            exit 1
        fi
        kill "$PID" 2>/dev/null
        echo "  ✓ Sent SIGTERM to PID $PID"
        sleep 1
        if kill -0 "$PID" 2>/dev/null; then
            echo "  Process still running. Force kill? (y/n)"
            read -r ans
            [ "$ans" = "y" ] && kill -9 "$PID" && echo "  ✓ Force killed PID $PID"
        else
            echo "  ✓ Process terminated"
        fi
        ;;
    kill-name)
        NAME="$2"
        [ -z "$NAME" ] && echo "  Usage: vajra-task kill-name <name>" && exit 1
        pkill -f "$NAME" 2>/dev/null
        echo "  ✓ Killed all processes matching '$NAME'"
        ;;
    mem)
        echo "◆ Top Memory Consumers:"
        ps aux --sort=-%mem | head -10 | awk '{printf "  %-6s %-6s %s\n", $2, $4"%", $11}'
        ;;
    cpu)
        echo "◆ Top CPU Consumers:"
        ps aux --sort=-%cpu | head -10 | awk '{printf "  %-6s %-6s %s\n", $2, $3"%", $11}'
        ;;
    tree)
        echo "◆ Process Tree:"
        pstree -p 2>/dev/null | head -30 || ps -e --forest
        ;;
    search)
        NAME="$2"
        [ -z "$NAME" ] && echo "  Usage: vajra-task search <name>" && exit 1
        echo "◆ Processes matching '$NAME':"
        ps aux | grep "$NAME" | grep -v grep
        ;;
    *)
        echo "Usage: vajra-task {list|kill <PID>|kill-name <name>|mem|cpu|tree|search <name>}"
        ;;
esac
TM
chmod +x "$TM_DIR/task-manager.sh"
ln -sf "$TM_DIR/task-manager.sh" /usr/local/bin/vajra-task 2>/dev/null || true

echo "  ✓ Task manager installed"
echo "  ◆ Usage: vajra-task {list|kill|mem|cpu|tree|search}"
echo "◆ Done"
