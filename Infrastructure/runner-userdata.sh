#!/bin/bash

apt-get update
sudo apt-get install awscli -y

# Install Docker
sudo apt install docker.io -y
sudo systemctl start docker