variable "env" {
  description = "環境"
  type        = string
}

variable "key_name" {
  description = "EC2キーペア名 "
  type        = string
}

variable "ssh_location" {
  description = "SSHアクセス許可のIP（例：0.0.0.0/0）"
  type        = string
}

variable "DBusername" {
  description = "RDSのユーザー名"
  type        = string
}

variable "DBpassword" {
  description = "RDSのパスワード"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "アラート用Email"
}