resource "aws_acm_certificate" "aws_website_cert" {
    domain_name         = var.domain_name
    validation_method   = "DNS"
}

resource "aws_route53_record" "aws_website_certificate_validation" { 
    name        = tolist(aws_acm_certificate.aws_website_cert.domain_validation_options)[0].resource_record_name
    type        = tolist(aws_acm_certificate.aws_website_cert.domain_validation_options)[0].resource_record_type
    zone_id     = aws_route53_zone.aws_website_zone.zone_id
    records     = [tolist(aws_acm_certificate.aws_website_cert.domain_validation_options)[0].resource_record_value]
    ttl         = "60"
}

resource "aws_acm_certificate_validation" "aws_website_cert_validation" {
    certificate_arn = aws_acm_certificate.aws_website_cert.arn
    validation_record_fqdns = [
        aws_route53_record.aws_website_certificate_validation.fqdn,
    ]
}


