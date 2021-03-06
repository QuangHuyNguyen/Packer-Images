#!/bin/bash -eux

# Installing unzip
apt-get install unzip -y 

# Installing AWS
apt-get install awscli -y

# Installing graphviz
apt-get install graphviz -y

# Install Xclip
apt-get install xclip -y

# Install Open JDK 8
apt-get install openjdk-8-jdk -y

# Install Maven
apt-get install maven -y

# Install Docker
apt-get install docker.io -y
usermod -aG docker $USER
