# Create SSL/TLS certificate
resource "aws_acm_certificate" "main_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create Route 53 hosted zone
resource "aws_route53_zone" "main_hosted_zone" {
    name = var.domain_name

    tags = {
      Environment = var.env
    }
}

# creating dns record of cert in hosted zone.
# DNS verification works by creating a CNAME record in the DNS zone created for the domain.
resource "aws_route53_record" "site_cert_dns_record" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.main_hosted_zone.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "site_cert_validation" {
  certificate_arn         = aws_acm_certificate.main_cert.arn
  validation_record_fqdns = [aws_route53_record.site_cert_dns_record.fqdn]
}

# alias to cdn
resource "aws_route53_record" "a-record" {
  zone_id = aws_route53_zone.main_hosted_zone.zone_id
  name = var.domain_name
  type = "A"

  alias {
    name = var.cdn_domain_name
    zone_id = var.hosted_zone_id
    evaluate_target_health = false
  }

}