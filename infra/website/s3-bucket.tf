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
    bucket = "aws_webste_logs_${var.domain_name}"
    acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "codepipeline_artifacts" {
    bucket = "aws_webste_logs_${var.domain_name}"
    acl    = "log-delivery-write"
}