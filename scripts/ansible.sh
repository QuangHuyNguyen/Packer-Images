#!/bin/bash -eux

# Install Ansible repository.
apt -y update && apt-get -y upgrade
apt -y install software-properties-common
apt-add-repository ppa:ansible/ansible

apt-get -qq install python -y

# Install Ansible.
apt-get update
apt-get install ansible -y
