#!/bin/bash

# Run by cloud-init
set -e

function update() {
  apt-get update
  apt-get install -y git curl
}

function system_config() {
  sudo sysctl -w net.ipv4.ip_forward=1
}

function tailscale_config() {
  curl -fsSL https://tailscale.com/install.sh | sh
  tailscale up --authkey "${tailscale_auth_key}" --advertise-exit-node
}

function main() {
  update
  system_config
  tailscale_config
}

main
