#!/bin/bash
# Vajra OS Docker Setup
set -e
echo "=== Vajra OS Docker Setup ==="
echo "[*] Installing Docker..."
apt-get install -y docker.io docker-compose 2>/dev/null || true
systemctl enable docker 2>/dev/null || true
systemctl start docker 2>/dev/null || true
usermod -aG docker "$USER" 2>/dev/null || true
echo "[+] Docker installed"
echo "[*] Pulling useful images..."
docker pull hello-world 2>/dev/null || true
docker pull ubuntu:latest 2>/dev/null || true
docker pull python:3.12-slim 2>/dev/null || true
docker pull node:20-slim 2>/dev/null || true
docker pull nginx:latest 2>/dev/null || true
docker pull postgres:16 2>/dev/null || true
docker pull redis:7 2>/dev/null || true
echo "[+] Images pulled"
docker network create vajra-net 2>/dev/null || true
echo "[+] Vajra network created"
echo "Note: Log out and back in for docker group"