resource "aws_acm_certificate" "main_cert" {
  domain_name       = var.bucket_name
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}