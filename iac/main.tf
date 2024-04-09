terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider Region 1
provider "aws" {
  region = "ap-south-1"
  alias = "indian_region"
}

provider "aws" {
  region = "us-east-1"
  alias = "north_v_region"
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  providers = {
    aws = aws.indian_region
  }
}

module "acm" {
  source = "./modules/acm"
  bucket_name = var.bucket_name
  providers = {
    aws = aws.north_v_region
  }
}