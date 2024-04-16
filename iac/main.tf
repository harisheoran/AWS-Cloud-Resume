terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  backend "s3"{
    bucket                 = "harisheoran-tf-state"
    region                 = "ap-south-1"
    key                    = "terraform.tfstate"
    dynamodb_table         = "harisheoran-dynamo-db"
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


provider "vault" {
  address = "http://13.201.66.231:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = var.role_id
      secret_id = var.secret_id
    }
  }
}

data "vault_kv_secret_v2" "my_secret" {
  mount = "kv" // change it according to your mount
  name  = "secret" // change it according to your secret
}

# Create Hosted zone first, as need to add NS in Hostinger
module "route53_hosted_zone" {
  source = "./modules/route53"
  domain_name = var.bucket_domain
  env = var.env
}

# then, create certificate in North Verginia Region
module "cert" {
  source = "./modules/cert"
  count = var.is_zone ? 0 : 1
  depends_on = [ module.route53_hosted_zone ]
  domain_name = var.bucket_domain
  route53_hosted_zoneId = module.route53_hosted_zone.route53_hosted_zoneId
  providers = {
    aws =aws.north_v_region
  }
}

module "s3" {
  source = "./modules/s3"
  count = var.is_zone ? 0 : 1
  bucket_name = var.bucket_domain
  env = data.vault_kv_secret_v2.my_secret.data["env"]
  providers = {
    aws = aws.main_region
  }
}

module "cdn" {
  source = "./modules/cdn"
  count = var.is_zone ? 0 : 1
  depends_on = [ module.route53_hosted_zone, module.route53_hosted_zone, module.s3, module.cert]
  acm_cert_arn = module.cert[0].acm_cert_arn
  origin_domain = module.s3[0].origin_domain
  route53_hosted_zoneId = module.route53_hosted_zone.route53_hosted_zoneId
  bucket_arn = module.s3[0].bucket_arn
  bucket_id = module.s3[0].bucket_id
  domain = var.domain
}

