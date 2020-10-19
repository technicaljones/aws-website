# cloudfront distribution
resource "aws_cloudfront_distribution" "aws_website_distribution" {
    origin {
        domain_name = aws_s3_bucket.aws_website.bucket_domain_name
        origin_id = "${var.domain_name}-origin"
    }

    enabled             = true
    aliases             = [var.domain_name]
    price_class         = "PriceClass_100"
    default_root_object = "index.html"

    default_cache_behavior {

        allowed_methods  = [
            "DELETE", 
            "GET", 
            "HEAD", 
            "OPTIONS", 
            "PATCH",
            "POST", 
            "PUT"
        ]

        cached_methods   = [
            "GET", 
            "HEAD"
        ]

        target_origin_id = "${var.domain_name}-origin"

        forwarded_values {
            query_string = true
            cookies {
                forward = "all"
            }
        }

        viewer_protocol_policy = "https-only"
        min_ttl                = 0
        default_ttl            = 1000
        max_ttl                = 86400
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        acm_certificate_arn      = aws_acm_certificate_validation.aws_website_cert_validation.certificate_arn
        minimum_protocol_version = "TLSv1"
        ssl_support_method       = "sni-only"
  }
}