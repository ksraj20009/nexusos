#!/bin/bash
# Vajra OS - Built-in File Manager
case "${1:-pwd}" in
    pwd) pwd; ls -la ;;
    ls) ls -la "${2:-.}" ;;
    cd) cd "${2:-$HOME}" 2>/dev/null && pwd ;;
    mkdir) mkdir -p "$2" && echo "  Created: $2" ;;
    rm) [ -z "$2" ] && echo "  Usage: vajra-files rm <file>" && exit 1; rm -i "$2" ;;
    cp) [ -z "$2" ] || [ -z "$3" ] && echo "  Usage: vajra-files cp <src> <dst>" && exit 1; cp -r "$2" "$3" && echo "  Copied" ;;
    mv) [ -z "$2" ] || [ -z "$3" ] && echo "  Usage: vajra-files mv <src> <dst>" && exit 1; mv "$2" "$3" && echo "  Moved" ;;
    find) find "${2:-.}" -name "${3:-*}" 2>/dev/null | head -30 ;;
    size) du -sh "${2:-.}" 2>/dev/null ;;
    tree) find "${2:-.}" -print | sed -e "s;[^/]*/;|  ;g;s;|  \([^ ]\);+- \1;" | head -30 ;;
    info) stat "${2:-.}" 2>/dev/null ;;
    help|*) echo "  Vajra OS - File Manager: pwd ls cd mkdir rm cp mv find size tree info" ;;
esac
