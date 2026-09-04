#!/bin/bash
# Run Vajra OS in Docker
echo "◆ Vajra OS Docker Launcher"
echo "=========================="
echo ""
echo "Building image..."
docker build -t vajra-os:1.0 -f docker/Dockerfile .
echo ""
echo "Starting Vajra OS container..."
echo "  Buddhi AI API: http://localhost:5210"
echo "  Vaultwarden:   http://localhost:8222"
echo "  WireGuard VPN: udp://localhost:51820"
echo ""
docker run -d --name vajra \
  -p 5210:5210 \
  --cap-add NET_ADMIN \
  --hostname vajra \
  vajra-os:1.0
echo ""
echo "◆ Vajra OS running in Docker!"
echo "  Test: curl http://localhost:5210/status"
echo ""
echo "  To enter:  docker exec -it vajra buddhi"
echo "  To stop:   docker stop vajra"
echo "  To remove: docker rm vajra"
