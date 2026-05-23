#!/bin/bash

set -e

echo "--- Starting Environment Setup ---"

echo "Updating system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

echo "Installing stress-ng and fallocate..."
sudo apt-get install -y stress-ng

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

echo "Configuring Docker permissions for chaosuser..."
sudo usermod -aG docker chaosuser

echo "Pulling Pumba chaos tool and NGINX victim container..."
sudo docker pull gaiaadm/pumba
sudo docker pull nginx:latest

echo "--- Setup Complete! Please log out and log back in for group changes to take effect. ---"
