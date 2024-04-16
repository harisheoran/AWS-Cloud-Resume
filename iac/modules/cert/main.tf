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

# creating dns record of cert in hosted zone.
# DNS verification works by creating a CNAME record in the DNS zone created for the domain.
resource "aws_route53_record" "site_cert_dns_record" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.main_cert.domain_validation_options)[0].resource_record_type
  zone_id         = var.route53_hosted_zoneId
  ttl             = 60
}

resource "aws_acm_certificate_validation" "site_cert_validation" {
  certificate_arn         = aws_acm_certificate.main_cert.arn
  validation_record_fqdns = [aws_route53_record.site_cert_dns_record.fqdn]
}
