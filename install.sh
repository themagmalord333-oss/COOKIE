#!/usr/bin/env bash

set -e

echo "========================================="
echo " COOKIE API Auto Installer"
echo "========================================="

echo ""
echo "[1/9] Updating System..."
sudo apt update && sudo apt upgrade -y

echo ""
echo "[2/9] Installing Required Packages..."
sudo apt install -y \
git \
curl \
ffmpeg \
python3 \
python3-pip \
python3-venv

echo ""
echo "[3/9] Installing Node.js 22..."

if command -v node >/dev/null 2>&1; then
    NODE_MAJOR=$(node -v | cut -d'.' -f1 | tr -d 'v')
else
    NODE_MAJOR=0
fi

if [ "$NODE_MAJOR" -lt 22 ]; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js already installed."
fi

echo ""
echo "[4/9] Creating Python Virtual Environment..."

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate

echo ""
echo "[5/9] Upgrading pip..."

pip install --upgrade pip

echo ""
echo "[6/9] Installing Latest yt-dlp..."

pip uninstall -y yt-dlp || true

pip install -U git+https://github.com/yt-dlp/yt-dlp.git

pip install -U "yt-dlp[default]"

echo ""
echo "[7/9] Installing Python Requirements..."

pip install -r requirements.txt

echo ""
echo "[8/9] Checking Installation..."

echo ""
echo "Node Version:"
node -v

echo ""
echo "yt-dlp Version:"
yt-dlp --version

echo ""
echo "Checking yt-dlp-ejs..."

pip show yt-dlp-ejs

echo ""
echo "[9/9] Testing JS Runtime..."

yt-dlp -v --js-runtimes node -F https://youtu.be/U0EI7XFkkV4 >/dev/null

echo ""
echo "========================================="
echo " INSTALLATION COMPLETED SUCCESSFULLY"
echo "========================================="
echo ""
echo "Run the API:"
echo ""
echo "source venv/bin/activate"
echo "uvicorn app:app --host 0.0.0.0 --port 8000"
echo ""
echo "API:"
echo "http://SERVER_IP:8000"
echo ""
echo "Health:"
echo "http://SERVER_IP:8000/health"
echo ""
echo "========================================="