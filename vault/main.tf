terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider Region
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "vault_server" {
  ami           = "ami-007020fd9c84e18c7"
  instance_type = "t2.micro"
  key_name = "aws-key-pair"
  vpc_security_group_ids = [aws_security_group.vault_sevver_aws_security_group.id]
  associate_public_ip_address = true
}


resource "aws_security_group" "vault_sevver_aws_security_group" {
    name = "security-group-terraform"
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8200
        to_port = 8200
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}