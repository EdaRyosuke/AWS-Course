# WAF
resource "aws_wafv2_web_acl" "waf" {
  name  = "${var.env}-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.env}-web-acl"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleset"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

#WAFとALBの紐付け
resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}

# WAFログ保存先(ロググループ)
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-group-${var.env}"
  retention_in_days = 30
}

# WAFログ出力先
resource "aws_wafv2_web_acl_logging_configuration" "waf_configuration" {
  resource_arn            = aws_wafv2_web_acl.waf.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
}

# BLOCK検出
resource "aws_cloudwatch_log_metric_filter" "waf_block_filter" {
  name           = "${var.env}-WAFBlockedRequestsFilter"
  log_group_name = aws_cloudwatch_log_group.waf_logs.name
  pattern        = "{ $.action = \"BLOCK\" }"

  metric_transformation {
    name      = "${var.env}-WAFBlockedRequests"
    namespace = "MyApp/Logs"
    value     = "1"
  }
}

#通知トリガー(BLOCK検出)
resource "aws_cloudwatch_metric_alarm" "waf_block_alarm" {
  alarm_name          = "${var.env}-WAF-Blocked-Requests-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = aws_cloudwatch_log_metric_filter.waf_block_filter.metric_transformation[0].name
  namespace           = "MyApp/Logs"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_topic_arn]
}
