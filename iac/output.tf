output "nameservers" {
  value = module.route53_hosted_zone.nameservers
}

output "cdn_url" {
  value = module.cdn.cdn_url
}
