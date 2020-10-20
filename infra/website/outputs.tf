output "cloudfront_domain_name" {
    value = aws_cloudfront_distribution.aws_website_distribution.domain_name
}

output "domain_name" {
    value = var.domain_name
}