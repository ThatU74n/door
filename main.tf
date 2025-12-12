terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.0.0"
    }

    # azure = {
    #   source = "hashicorp/azurerm"
    #   version = ">= 5.0.0"
    # }
    #
    # gcp = {
    #   source = "hashicorp/google"
    #   version = ">= 5.0.0"
    # }

    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }
}

resource "null_resource" "precondition_validation" {
  lifecycle {
    precondition {
      condition = (var.cloud_provider != "aws" ||
        (
          length(var.aws_access_key) > 0 &&
          length(var.aws_secret_key) > 0 &&
          length(var.aws_region) > 0
        )
      )

      
      error_message = "When provider is 'aws', both 'aws_key' and 'aws'"
    } 

    precondition {
      condition = (var.cloud_provider != "digitalocean" ||
        (
          length(var.digital_ocean_token) > 0
        )
      )
      
      error_message = "When provider is 'digitalocean', 'digital_ocean_token' "
    }
  }
}

output "ip" {
  value = compact([
    try(module.aws[0].ip, null),
    try(module.digital-ocean[0].ip, null)
  ])
}

provider "aws" {
  alias = "aws"
  region = var.aws_region
  access_key = var.cloud_provider == "aws" ? var.aws_access_key : null
  secret_key = var.cloud_provider == "aws" ? var.aws_secret_key : null
}

provider "digitalocean" {
  alias = "do"
  token = var.cloud_provider == "digitalocean" ? var.digital_ocean_token : null
}

module "aws" {
  count = var.cloud_provider == "aws" ? 1 : 0
  source = "./modules/aws"
  providers = {
    aws = aws.aws
  }
  tailscale_auth_key = var.tailscale_auth_key
}

module "digital-ocean" {
  count = var.cloud_provider == "digitalocean" ? 1 : 0 
  source = "./modules/digital-ocean"
  providers = {
    digitalocean = digitalocean.do
  }
  tailscale_auth_key = var.tailscale_auth_key
}

