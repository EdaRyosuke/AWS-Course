variable "env" {
  description = "環境"
  type        = string
}

variable "key_name" {
  description = "EC2キーペア名"
  type        = string
}

variable "vpc_id" {}

variable "public_subnet1a_id" {}

variable "SSHlocation" {
  description = "SSH接続するIPのCIDRブロック"
  type        = string
}
