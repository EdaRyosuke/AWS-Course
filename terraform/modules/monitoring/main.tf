# SNSトピック
resource "aws_sns_topic" "alarm_topic" {
  name = "ALARM"
}

# SNS通知先
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

#通知トリガー(EC2インスタンスCPU使用率)
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when CPU usage exceeds 80% for 4 minutes."
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
  dimensions = {
    InstanceId = var.instance_main_id
  }
}
