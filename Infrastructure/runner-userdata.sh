#!/bin/bash

apt-get update
sudo apt-get install awscli -y
sudo apt-get install jq -y

#Install Trivy
curl -o trivy_0.46.1_Linux-64bit.tar.gz -L https://github.com/aquasecurity/trivy/releases/download/v0.46.1/trivy_0.46.1_Linux-64bit.tar.gz
tar xzf ./trivy_0.46.1_Linux-64bit.tar.gz
sudo mv trivy /usr/local/bin/
sudo chmod +x /usr/local/bin/trivy

# Install Docker
sudo apt install docker.io -y
sudo systemctl start docker

#Install Kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-02/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc