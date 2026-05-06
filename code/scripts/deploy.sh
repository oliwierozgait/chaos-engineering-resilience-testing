#!/bin/bash

# --- Chaos Lab Environment Deployment Script ---
# This script automates the installation of Docker and Chaos Engineering tools
# on an Ubuntu 22.04 LTS instance.

set -e # Exit immediately if a command exits with a non-zero status

echo "--- Starting Environment Setup ---"

# 1. Update system packages
echo "Updating system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# 2. Install Chaos Engineering tools (OS-level)
echo "Installing stress-ng and fallocate..."
sudo apt-get install -y stress-ng

# 3. Install Docker Engine
echo "Installing Docker Engine..."
sudo apt-get install -y ca-certificates cursor-curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Configure Docker permissions
echo "Configuring Docker permissions for chaosuser..."
sudo usermod -aG docker chaosuser

# 5. Pull Chaos tools and images
echo "Pulling Pumba chaos tool and NGINX victim container..."
sudo docker pull gaiaadm/pumba
sudo docker pull nginx:latest

echo "--- Setup Complete! Please log out and log back in for group changes to take effect. ---"








