output "nameservers" {
  value = aws_route53_zone.main_hosted_zone.name_servers
}

output "route53_hosted_zoneId" {
  value = aws_route53_zone.main_hosted_zone.zone_id
}