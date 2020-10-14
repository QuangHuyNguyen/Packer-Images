#!/bin/bash -eux

# Set Install version
TERRAFORM_VERSION="0.13.4"
WORKDIR=/tmp/terraform
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Install Terraform 
curl -f "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
sudo unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/
sudo chmod +x  /usr/local/bin/terraform
cd ~
rm -rf "$WORKDIR"
