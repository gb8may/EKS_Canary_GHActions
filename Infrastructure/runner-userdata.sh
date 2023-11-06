#!/bin/bash

apt-get update
sudo apt-get install awscli -y
sudo apt-get install jq -y

# Install Docker
sudo apt install docker.io -y
sudo systemctl start docker