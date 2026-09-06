#!/bin/bash
# Vajra OS GPU Benchmark
set -e
echo "=== Vajra OS GPU Benchmark ==="
echo "[*] GPU info:"
lspci | grep -i vga
echo ""
echo "[*] OpenGL info:"
glxinfo | grep -E "OpenGL vendor|OpenGL renderer|OpenGL version" 2>/dev/null || apt-get install -y mesa-utils && glxinfo | grep -E "OpenGL vendor|OpenGL renderer|OpenGL version"
echo ""
echo "[*] Running glxgears (30 second benchmark)..."
timeout 30 glxgears 2>/dev/null && echo "[+] Benchmark complete" || echo "Install mesa-utils for glxgears"
echo ""
echo "[*] Vulkan info:"
vulkaninfo --summary 2>/dev/null || echo "Install vulkan-tools for Vulkan info"
echo "[+] GPU benchmark done"