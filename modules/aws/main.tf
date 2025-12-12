terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_security_group" "door-sg" {
  name        = "door-node-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "door-key" {
  key_name = "door-key"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

resource "aws_instance" "door" {

  ami           = "ami-0818ff4e4d072e0ec"
  instance_type = "t2.micro"

  key_name = "door-key"
  vpc_security_group_ids = [aws_security_group.door-sg.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.0985"
      spot_instance_type = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }

  user_data = templatefile("${path.root}/setup.sh", {
    tailscale_auth_key = var.tailscale_auth_key
  })

  tags = {
    Name = "door"
  }
}
