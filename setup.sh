#!/bin/bash

function update() {
  sudo apt-get update
  sudo apt-get install -y git curl
}

function system_config() {
  sudo sysctl -w net.ipv4.ip_forward=1
}

function tailscale_config() {
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up --authkey "${tailscale_auth_key}" --advertise-exit-node
}

function main() {
  update
  system_config
  tailscale_config
}

main
