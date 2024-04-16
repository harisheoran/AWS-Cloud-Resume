variable "main_region" {
  type = string
  description = "Main region for resources"
}

variable "cert_region" {
  type = string
  description = "SSL/TLS certificate region"
}

variable "bucket_domain" {
    type = string
}

variable "env" {
  type = string
}

variable "domain" {
  type = string
}

variable "is_zone" {
  type = bool
  description = "So that we can update ns"
}

variable "role_id" {
  type = string
  description = "Role Id of vault"
}

variable "secret_id" {
  type = string
  description = "Secret Id of vault"
}

variable "s3_remote_backend_name" {
  type = string
  description = "Name of s3 bucket used for remote backend"
}

variable "dynamo_db_remote_backend" {
  type = string
  description = "name of dynamo db for remote backend"
}

variable "remote_backend_region" {
  type = string
  description = "Region of remote backend"
}