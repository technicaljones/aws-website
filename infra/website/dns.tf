resource "aws_route53_zone" "aws_website_zone" {
    name = var.domain_name
}

resource "aws_route53_record" "aws_website_cname" {
    zone_id = aws_route53_zone.aws_website_zone.zone_id
    name    = var.domain_name
    type    = "NS"
    ttl     = "30"
    records = [
        aws_route53_zone.aws_website_zone.name_servers.0,
        aws_route53_zone.aws_website_zone.name_servers.1,
        aws_route53_zone.aws_website_zone.name_servers.2,
        aws_route53_zone.aws_website_zone.name_servers.3
    ]
}

resource "aws_route53_record" "root_domain" {
    zone_id = aws_route53_zone.aws_website_zone.zone_id
    name = var.domain_name
    type = "A"

    alias {
        name                    = aws_cloudfront_distribution.aws_website_distribution.domain_name
        zone_id                 = aws_cloudfront_distribution.aws_website_distribution.hosted_zone_id
        evaluate_target_health  = false
    }
}