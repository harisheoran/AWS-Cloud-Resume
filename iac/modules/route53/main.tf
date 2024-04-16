# Create Route 53 hosted zone
resource "aws_route53_zone" "main_hosted_zone" {
    name = var.domain_name

    tags = {
      Environment = var.env
    }
}