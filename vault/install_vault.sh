#!/bin/bash

################################
# Author: Harish
# Purpose: Install and start the Hashicorp vault server
# Date: 16th April, 2024
# Verison: v1.0.0
################################

set -e

# Update the system
sudo apt update && sudo apt install gpg

# Dowload the signing key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Verify the key
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

# Clone the vault repo
sudo mkdir -p $GOPATH/src/github.com/hashicorp && cd $_
sudo git clone https://github.com/hashicorp/vault.git
cd vault

# Install the vault
sudo snap install vault

# Start the vault server
export VAULT_ADDR='http://0.0.0.0:8200'
vault server -dev -dev-listen-address="0.0.0.0:8200"
