terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  type = string 
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "door-key" {
  name   = "door-key"
  public_key = file("~/.ssh//id_ed25519.pub")
}

resource "digitalocean_droplet" "door" {
  name   = "door"
  image  = "debian-12-x64"

  region = "sgp1"
  size   = "s-1vcpu-1gb" 

  ssh_keys = [digitalocean_ssh_key.door-key.id]
  user_data = templatefile("setup.sh", {
    tailscale_auth_key = var.tailscale_auth_key
  })
}
