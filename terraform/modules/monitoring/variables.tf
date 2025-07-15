variable "alert_email" {
  description = "SNSトピック送信先Emailアドレス"
  type        = string
}

variable "instance_main_id" {
  description = "EC2インスタンス(メイン)のID"
  type        = string
}
