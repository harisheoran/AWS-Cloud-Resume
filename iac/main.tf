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
  alias = "main_region"
}

provider "aws" {
  region = "us-east-1"
  alias = "north_v_region"
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_domain
  providers = {
    aws = aws.main_region
  }
}

module "route53_hosted_zone" {
  source = "./modules/route53"
  domain_name = var.bucket_domain
  cdn_domain_name = module.cdn.cdn_url
  hosted_zone_id = module.cdn.hosted_zone_id
  env = var.env
  providers = {
    aws = aws.north_v_region
  }
}

module "cdn" {
  source = "./modules/cdn"
  acm_cert_arn = module.route53_hosted_zone.acm_cert_arn
  origin_domain = module.s3.origin_domain
  bucket_arn = module.s3.bucket_arn
  bucket_id = module.s3.bucket_id
  domain = var.domain
}