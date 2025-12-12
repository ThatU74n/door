variable "tailscale_auth_key" {
  type = string
  sensitive = true
}

variable "region" {
  type = string
  default = "sgp1" 
}
