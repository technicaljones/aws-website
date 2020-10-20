resource "aws_route53_record" "root_domain" {
    count   = var.owned_domain ? 1 : 0
    zone_id = data.aws_route53_zone.aws_website_zone[count.index].zone_id
    name = var.domain_name
    type = "A"

    alias {
        name                    = aws_cloudfront_distribution.aws_website_distribution.domain_name
        zone_id                 = aws_cloudfront_distribution.aws_website_distribution.hosted_zone_id
        evaluate_target_health  = false
    }
}
