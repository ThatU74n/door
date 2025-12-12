variable "tailscale_auth_key" {
  description = "The Tailscale authentication key for the node."
  type        = string
  sensitive   = true
}

variable "cloud_provider" {
  type = string
  validation {
    condition = contains([
      "aws",
      "digitalocean"
    ], var.cloud_provider)
    error_message = "Provider must be one of 'aws' | 'digitalocean'."
  }
}

variable "aws_access_key" {
  type = string
  
  nullable = true
}

variable "aws_secret_key" {
  type = string 
  nullable = true 
  sensitive = true
}

variable "aws_region" {
  type = string
  default = "us-east-1"
} 

variable "digital_ocean_token" {
  type = string 
  sensitive = true
  nullable = true
}

variable "digital_ocean_region" {
  type    = string
  default = "sgp1"
}
