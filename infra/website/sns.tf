resource "aws_sns_topic" "aws_website_alarms" {
    name = "${var.short_name}-alarms"
}

resource "aws_sns_topic_subscription" "aws_website_alarm_alerts"{
    count       = length(var.alert_sms)
    topic_arn   = aws_sns_topic.aws_website_alarms.arn
    protocol    = "sms"
    endpoint    = var.alert_sms[count.index]
}