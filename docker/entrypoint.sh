#!/bin/bash
# Vajra OS Docker Entrypoint
echo "◆ वज्र OS — Docker Container Starting..."
echo "  Version: $VAJRA_VERSION"
echo "  User: $USER"
echo ""
echo "  Starting Tor..."
sudo tor --runas debian-tor 2>/dev/null &
sleep 2
echo "  Starting Buddhi AI..."
exec python3 /opt/vajra/ai/buddhi-ai.py --service
