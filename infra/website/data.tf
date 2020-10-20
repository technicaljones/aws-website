data "aws_route53_zone" "aws_website_zone" {
  count        = var.owned_domain ? 1 : 0
  name         = var.domain_name
}