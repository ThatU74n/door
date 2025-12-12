terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

resource "digitalocean_ssh_key" "door-key" {
  name   = "door-key"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

resource "digitalocean_droplet" "door" {
  name   = "door"
  image  = "debian-12-x64"

  region = var.region
  size   = "s-1vcpu-1gb" 

  ssh_keys = [digitalocean_ssh_key.door-key.id]
  user_data = templatefile("${path.root}/setup.sh", {
    tailscale_auth_key = var.tailscale_auth_key
  })
}
