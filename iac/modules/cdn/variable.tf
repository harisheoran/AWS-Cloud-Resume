variable "origin_domain" {
  type = string
  description = "S3 bucket name"
}

variable "acm_cert_arn" {
  type = string
  description = "ARN of ACN certificate"
}

variable "bucket_arn" {
  type = string
  description = "ARN of S3 bucket"
}

variable "bucket_id" {
  type = string
  description = "S3 Bucket ID"
}

variable "domain" {
  type = string
  description = "Main Domain name"
}