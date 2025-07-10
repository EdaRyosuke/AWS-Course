variable "env" {
  description = "環境"
  type        = string
}

variable "alb_arn" {
  description = "ALBのARN"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNSトピックのARN"
  type        = string
}
