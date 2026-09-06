#!/bin/bash
# Vajra OS Kubernetes Setup (free, open source)
set -e
echo "=== Vajra OS Kubernetes Setup ==="
echo "  1. Install kubectl (free)"
echo "  2. Install minikube (local cluster, free)"
echo "  3. Install k3s (lightweight K8s, free)"
echo "  4. Start minikube"
echo "  5. Show cluster info"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" 2>/dev/null
       install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 2>/dev/null
       echo "[+] kubectl installed" ;;
    2) curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 2>/dev/null
       install minikube-linux-amd64 /usr/local/bin/minikube 2>/dev/null
       echo "[+] minikube installed" ;;
    3) curl -sfL https://get.k3s.io | sh - 2>/dev/null; echo "[+] k3s installed" ;;
    4) minikube start 2>/dev/null; echo "[+] minikube started" ;;
    5) kubectl cluster-info 2>/dev/null || k3s kubectl get nodes 2>/dev/null ;;
    6) exit 0 ;;
esac