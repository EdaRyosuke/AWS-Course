variable "env" {
  description = "環境"
  type        = string
}

variable "key_name" {
  description = "EC2キーペア名"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "public_subnet1a_id" {
  description = "パブリックサブネット1aのID"
  type        = string
}

variable "public_subnet1c_id" {
  description = "パブリックサブネット1cのID"
}

variable "ssh_location" {
  description = "SSH接続するIPのCIDRブロック"
  type        = string
}
