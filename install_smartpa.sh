#!/bin/bash

# Smart PA Modernization System Installer Script
# Runs on any Ubuntu system with internet access

set -e

echo "=== Updating system ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing Dependencies ==="
sudo apt install -y python3 python3-pip python3-venv git nodejs npm nginx

# Optional: install bluetooth utilities if handling Bluetooth audio switching
sudo apt install -y pulseaudio pulseaudio-module-bluetooth bluez

echo "=== Setting up project directory ==="
mkdir -p ~/smartpa
cd ~/smartpa

echo "=== Cloning Smart PA repository ==="
git clone https://github.com/YOURUSERNAME/smartpa.git .
# You should replace YOURUSERNAME with your actual GitHub username once you have repo.

echo "=== Setting up Python virtual environment ==="
python3 -m venv venv
source venv/bin/activate

echo "=== Installing Python backend dependencies ==="
pip install -r backend/requirements.txt

echo "=== Installing and Building Frontend ==="
cd frontend
npm install
npm run build
cd ..

echo "=== Setting up Nginx to serve frontend ==="
sudo cp deploy/nginx_smartpa.conf /etc/nginx/sites-available/smartpa
sudo ln -s /etc/nginx/sites-available/smartpa /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

echo "=== Creating systemd service ==="

# Write systemd unit file
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

echo "=== Enabling and starting Smart PA service ==="
sudo systemctl daemon-reload
sudo systemctl enable smartpa
sudo systemctl start smartpa

echo "=== Installation Complete! ==="
echo "Access your Smart PA Modernizer by visiting http://your-device-ip in your browser."
