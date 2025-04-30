# 🔊 Smart PA Modernization System

The Smart PA Modernization System replaces failing, power-hungry public address (PA) amplifier boards with a low-power, app-controlled system powered by a Raspberry Pi Zero 2W or similar device.  
It enables users to control the PA system via iOS, Android, desktop, or web browser — including input switching between Bluetooth, AUX, and XLR, all in a visually immersive interface.

---

## ⚙️ Features

- 🎚️ Switch between Bluetooth, XLR, and AUX inputs
- 📱 Remote control via mobile, desktop, or web app
- 🎨 3D-rendered UI (React + Three.js)
- 🔁 Auto-start on boot using systemd
- 🌐 Web interface served with Nginx
- 🧠 Lightweight Python (Flask) backend

---

## ✅ Pre-Installation Requirements

1. **Hardware**
   - Raspberry Pi Zero 2W (or Jetson, Pi 4, etc.)
   - USB Audio Interface (for AUX/XLR input)
   - Class D Amplifier board (TPA3116D2 or similar)
   - 5V or 24V Power supply (depending on your amp)
   - Active internet connection for install

2. **Operating System**
   - Ubuntu 20.04 / 22.04 or Raspberry Pi OS
   - Nginx, Git, Node.js, Python 3.10+

3. **GitHub Access**
   - [Create an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
   - Add the public key to your GitHub account
   - Ensure SSH access works:  
     `ssh -T git@github.com`

---

## 📦 Installation Steps

### Clone and Install

```bash
# Clone repo
git clone git@github.com:jeminai/smart-pa-modernization-system.git
cd smart-pa-modernization-system

# Make script executable
chmod +x install_smartpa.sh

# Run installer
./install_smartpa.sh

# This script will:
# Install dependencies (Python, Node.js, Nginx, PulseAudio)
# Set up the Python virtual environment
# Build the frontend
# Set up and link Nginx
# Create and enable the systemd service

🛠️ Post-Install Configuration

1. 🔧 Update Nginx Config
# Edit:
sudo nano /etc/nginx/sites-available/smartpa
# Find and replace YOUR_USERNAME with your actual system username:
root /home/YOUR_USERNAME/smartpa/frontend/build;
# Save and reload:
sudo nginx -t
sudo systemctl reload nginx

2. 🔧 Update systemd Service (if needed)
# Edit systemd service:
sudo nano /etc/systemd/system/smartpa.service
# Replace:
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/smartpa
# Apply changes:
sudo systemctl daemon-reload
sudo systemctl restart smartpa

🚀 Usage
Web UI: http://<your-device-ip>
API status: http://<your-device-ip>/api/status
Control audio input via UI (Bluetooth, XLR, AUX)
Control volume (future enhancement)
OTA firmware/web updates (future)

🧪 Testing
# Check Nginx status
sudo systemctl status nginx

# Check Smart PA backend
sudo systemctl status smartpa

# Test backend manually
curl http://localhost:5000/api/status

🧯 Troubleshooting
Issue	Solution
nginx default page	Ensure default site is removed: sudo rm /etc/nginx/sites-enabled/default
Permission denied	Check systemd User= value and ownership of /home/username/smartpa
SSL CAfile: none	Switch to SSH for GitHub access
App not loading	Run npm run build inside frontend/ and confirm Nginx root path is correct

📁 Project Structure
smart-pa-modernization-system/
├── backend/                # Python Flask API
├── frontend/               # React + Three.js frontend
├── deploy/                 # nginx config
├── install_smartpa.sh      # Full auto installer
└── README.md

📜 License
This project is licensed under the MIT License.

👤 Author
James Lionel Buck Jr.
Founder, Buck Trust Technologies
GitHub: jeminai
