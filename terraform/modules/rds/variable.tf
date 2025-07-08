variable "env" {
  description = "環境"
  type        = string
}

variable "private_subnet_list" {}

variable "DBusername" {
  type = string
}

variable "DBpassword" {
  type = string
}

variable "vpc_id" {}

variable "ec2_sg" {}
