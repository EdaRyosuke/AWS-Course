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
  type        = string
}

variable "env" {
  description = "環境"
  type        = string
}

variable "instance_main_id" {
  description = "EC2インスタンス(メイン)のID"
  type        = string
}
