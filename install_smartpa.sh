#!/bin/bash

# Updated Smart PA Installer — No GitHub clone

set -e

echo "=== Updating system ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing system dependencies ==="
sudo apt install -y python3 python3-pip python3-venv nodejs npm nginx pulseaudio pulseaudio-module-bluetooth bluez

echo "=== Setting up project directory ==="
mkdir -p ~/smartpa
cd ~/smartpa

# Optional: Placeholders to remind user to copy project files here manually
echo ">>> Place your backend/, frontend/, and deploy/ folders here manually if not already present."

echo "=== Setting up Python virtual environment ==="
python3 -m venv venv
source venv/bin/activate

if [ -f backend/requirements.txt ]; then
    echo "=== Installing Python backend dependencies ==="
    pip install -r backend/requirements.txt
else
    echo "!!! No backend/requirements.txt found, skipping Python dependencies."
fi

if [ -f frontend/package.json ]; then
    echo "=== Installing frontend dependencies and building ==="
    cd frontend
    npm install
    npm run build
    cd ..
else
    echo "!!! No frontend/package.json found, skipping frontend build."
fi

if [ -f deploy/nginx_smartpa.conf ]; then
    echo "=== Configuring nginx ==="
    sudo cp deploy/nginx_smartpa.conf /etc/nginx/sites-available/smartpa
    sudo ln -sf /etc/nginx/sites-available/smartpa /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl restart nginx
else
    echo "!!! No nginx config found. Skipping nginx setup."
fi

echo "=== Creating systemd service ==="

cat <<EOF | sudo tee /etc/systemd/system/smartpa.service
[Unit]
Description=Smart PA Backend Service
After=network.target

[Service]
User=$USER
WorkingDirectory=/home/$USER/smartpa
Environment="PATH=/home/$USER/smartpa/venv/bin"
ExecStart=/home/$USER/smartpa/venv/bin/python backend/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "=== Enabling and starting Smart PA systemd service ==="
sudo systemctl daemon-reload
sudo systemctl enable smartpa
sudo systemctl start smartpa

echo "=== Setup Complete ==="
echo "Visit: http://<your-device-ip> to access the Smart PA Web UI"
