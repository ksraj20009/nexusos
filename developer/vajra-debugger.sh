#!/bin/bash
# Vajra OS Debugger Tools
set -e
echo "=== Vajra OS Debugger Tools ==="
echo "  1. Python debugger (pdb)"
echo "  2. GDB (C/C++)"
echo "  3. strace (system calls)"
echo "  4. ltrace (library calls)"
echo "  5. valgrind (memory)"
echo "  6. perf (performance)"
echo "  7. Install debug tools"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "Python script: " s; python3 -m pdb "$s" ;;
    2) read -p "Binary: " b; gdb "$b" ;;
    3) read -p "Command to trace: " c; strace "$c" ;;
    4) read -p "Command to trace: " c; ltrace "$c" ;;
    5) read -p "Binary: " b; valgrind --leak-check=full "$b" ;;
    6) read -p "Command: " c; perf stat "$c" ;;
    7) apt-get install -y gdb strace ltrace valgrind 2>/dev/null; echo "[+] Debug tools installed" ;;
    8) exit 0 ;;
esac