#!/bin/bash -eux

# Install Ansible.
apt -y update && apt-get -y upgrade
apt-get install ansible -y
