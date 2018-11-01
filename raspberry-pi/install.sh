#!/bin/bash

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# This file assumes it can escalate to root with no password as is the default on a Raspberry Pi at first install
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

###############################
# Collect some information
###############################

# Hostname
read -p "Hostname (conductor): " hostname
hostname=${hostname:-conductor}

###############################
# Update the Raspberry Pi
###############################

# We'll run some commands to confirm the Raspberry Pi non-interactively
sudo raspi-config nonint do_hostname $hostname # change the hostname to conductor

# Update the Raspberry Pi to the latest version
sudo apt update
sudo apt upgrade -y

# Update the username and group
sudo usermod -L pi # Lock the account so no password will work

# Lock down access via SSH
sudo sed -i "s/#*PubkeyAuthentication.*/PubkeyAuthentication yes/" /etc/ssh/sshd_config
sudo sed -i "s/#*PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config
sudo sed -i "s/#*PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config

###############################
# Configure the software we need
###############################

# Install software packages we'll need
sudo apt install -y git python python-pip

# Install Docker and create user with permissions
sudo curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
sudo groupadd docker
sudo usermod -aG docker pi

# Install Docker Compose
sudo pip install docker-compose

###############################
# Install the Conductor repository and data directory
###############################

# Create the data directory
sudo mkdir /data
sudo chown -R pi:pi /data

# Clone the repo into the home directory as ~/app
git clone https://github.com/abstractvector/conductor ~/app

# Move to the repo and run docker-compose
cd ~/app
docker-compose up -d

###############################
# Reboot
###############################

# Reboot and everything should magically work
sudo reboot