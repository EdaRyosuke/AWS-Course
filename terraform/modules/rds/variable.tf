variable "env" {
  description = "環境"
  type        = string
}

variable "private_subnet_list" {
  description = "DBで使用するプライベートサブネットリスト"
  type        = list(string)
}

variable "DBusername" {
  description = "DBユーザーネーム"
  type        = string
}

variable "DBpassword" {
  description = "DBパスワード"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "ec2_sg" {
  description = "EC2のセキュリティグループ"
  type        = string
}
