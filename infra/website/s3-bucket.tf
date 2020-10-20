resource "aws_s3_bucket" "aws_website" {
    bucket = var.domain_name
    acl = "public-read"
    policy = data.aws_iam_policy_document.aws_website_policy.json

    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    logging {
        target_bucket = aws_s3_bucket.aws_website_logs.id
        target_prefix = "log/"
    }
}

resource "aws_s3_bucket" "aws_website_logs" {
    bucket = "aws.webste.logs.${var.domain_name}"
    acl    = "log-delivery-write"

    lifecycle_rule {
        id      = "1_week_logs"
        prefix  = "logs/"
        enabled = true
        expiration {
            days = 7
        }
    }
}

resource "aws_s3_bucket" "codepipeline_artifacts" {
    bucket = "artifacts.${var.domain_name}"
    acl    = "private"
}
