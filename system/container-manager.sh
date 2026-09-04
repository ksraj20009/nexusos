#!/bin/bash
# Vajra OS — Container Manager
# Docker/Podman management with Vajra branding
set -e

echo "◆ Vajra OS — Container Manager Setup"

CM_DIR="/opt/vajra/containers"
mkdir -p "$CM_DIR"

cat > "$CM_DIR/container-manager.sh" << 'CM'
#!/bin/bash
set -e

if command -v podman &>/dev/null; then
    RT=podman
elif command -v docker &>/dev/null; then
    RT=docker
else
    echo "  ⚠ No container runtime found. Installing Docker..."
    curl -fsSL https://get.docker.com | sudo sh 2>/dev/null
    sudo usermod -aG docker "$USER" 2>/dev/null || true
    RT=docker
fi

echo "  Using: $RT"

case "${1:-ps}" in
    ps|list)
        echo "◆ Running Containers:"
        $RT ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null
        echo ""
        echo "◆ All Containers:"
        $RT ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" 2>/dev/null
        ;;
    images)
        echo "◆ Container Images:"
        $RT images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>/dev/null
        ;;
    run)
        echo "◆ Starting container: $2"
        $RT run -d --name "$2" "${@:3}"
        echo "  ✓ Container $2 started"
        ;;
    stop)
        $RT stop "$2" 2>/dev/null
        echo "  ✓ Container $2 stopped"
        ;;
    start)
        $RT start "$2" 2>/dev/null
        echo "  ✓ Container $2 started"
        ;;
    rm|remove)
        $RT rm -f "$2" 2>/dev/null
        echo "  ✓ Container $2 removed"
        ;;
    clean)
        echo "◆ Cleaning unused containers and images..."
        $RT container prune -f 2>/dev/null
        $RT image prune -f 2>/dev/null
        $RT volume prune -f 2>/dev/null
        echo "  ✓ Cleanup complete"
        ;;
    stats)
        $RT stats --no-stream 2>/dev/null
        ;;
    compose)
        shift
        if command -v docker-compose &>/dev/null; then
            docker-compose "$@"
        else
            echo "  ⚠ docker-compose not installed"
        fi
        ;;
    net)
        echo "◆ Container Networks:"
        $RT network ls 2>/dev/null
        ;;
    *)
        echo "Usage: vajra-container {ps|images|run|stop|start|rm|clean|stats|compose|net}"
        ;;
esac
CM
chmod +x "$CM_DIR/container-manager.sh"
ln -sf "$CM_DIR/container-manager.sh" /usr/local/bin/vajra-container 2>/dev/null || true

echo "  ✓ Container manager installed"
echo "  ◆ Usage: vajra-container {ps|images|run|stop|start|rm|clean|stats}"
echo "◆ Done"
