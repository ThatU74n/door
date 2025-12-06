#!/bin/bash

sudo apt-get update
sudo apt-get install -y git curl

sudo sysctl -w net.ipv4.ip_forward=1

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --authkey "${tailscale_auth_key}" --advertise-exit-node
