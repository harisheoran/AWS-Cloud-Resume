output "nameservers" {
  value = aws_route53_zone.main_hosted_zone.name_servers
}

output "acm_cert_arn" {
  value = aws_acm_certificate.main_cert.arn
}