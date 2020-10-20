resource "aws_acm_certificate" "aws_website_cert" {
    count               = var.owned_domain ? 1 : 0
    provider            = aws.us-east-1
    domain_name         = var.domain_name
    validation_method   = "DNS"
}

resource "aws_route53_record" "aws_website_certificate_validation" { 
    count       = var.owned_domain ? 1 : 0
    name        = tolist(aws_acm_certificate.aws_website_cert[count.index].domain_validation_options)[0].resource_record_name
    type        = tolist(aws_acm_certificate.aws_website_cert[count.index].domain_validation_options)[0].resource_record_type
    zone_id     = data.aws_route53_zone.aws_website_zone[count.index].zone_id
    records     = [tolist(aws_acm_certificate.aws_website_cert[count.index].domain_validation_options)[0].resource_record_value]
    ttl         = "60"
}

resource "aws_acm_certificate_validation" "aws_website_cert_validation" {
    count                   = var.owned_domain ? 1 : 0
    provider                = aws.us-east-1
    certificate_arn         = aws_acm_certificate.aws_website_cert[count.index].arn
    validation_record_fqdns = [
        aws_route53_record.aws_website_certificate_validation[count.index].fqdn,
    ]
}


