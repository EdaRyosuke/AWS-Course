output "instance_main_id" {
  description = "EC2インスタンスID"
  value       = aws_instance.main.id
}

output "ec2_sg" {
  description = "EC2セキュリティグループID"
  value       = aws_security_group.ec2_sg.id
}
