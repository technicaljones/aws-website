resource "aws_cloudwatch_metric_alarm" "cloudfron_5xx" {
    provider            = aws.us-east-1
    alarm_name          = "${var.short_name}-AWS-CloudFront-High-5xx-Error-Rate"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 1
    metric_name         = "5xxErrorRate"
    namespace           = "AWS/CloudFront"
    period              = 60
    statistic           = "Average"
    threshold           = 5
    treat_missing_data  = "notBreaching"
    alarm_actions       = [aws_sns_topic.aws_website_alarms.arn]
    actions_enabled     = true

    dimensions = {
        DistributionId = aws_cloudfront_distribution.aws_website_distribution.id
        Region         = "Global"
    }
}