#!/usr/bin/env bash
set -euo pipefail

# CUDA version can be overridden via environment: CUDA_VERSION=12-4 ./install_deps.sh
CUDA_VERSION="${CUDA_VERSION:-12-4}"
DEBIAN_FRONTEND=noninteractive

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || { echo "Missing required command: $1" >&2; exit 1; }
}

echo "[+] Checking for sudo..."
need_cmd sudo

echo "[+] Ensuring apt transport tools are present..."
sudo apt-get update -y
sudo apt-get install -y wget gnupg build-essential make

echo "[+] Detecting Ubuntu version..."
. /etc/os-release
DIST="${ID}${VERSION_ID}"
echo "    -> ${DIST}"

echo "[+] Installing CUDA apt keyring..."
TMP_DEB="$(mktemp)"
wget -qO "$TMP_DEB" "https://developer.download.nvidia.com/compute/cuda/repos/${DIST}/x86_64/cuda-keyring_1.1-1_all.deb"
sudo dpkg -i "$TMP_DEB"
rm -f "$TMP_DEB"

echo "[+] Updating package lists..."
sudo apt-get update -y

echo "[+] Installing CUDA toolkit ${CUDA_VERSION}..."
sudo apt-get install -y "cuda-toolkit-${CUDA_VERSION}"

echo "[+] CUDA install complete. Add CUDA to PATH if desired:"
echo 'export PATH=/usr/local/cuda/bin:$PATH'
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH'

echo "[+] Verifying compilers..."
g++ --version | head -n 1
nvcc --version | head -n 1

echo "[✓] Done."
