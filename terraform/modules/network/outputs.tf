output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet1a_id" {
  value = aws_subnet.public_1a.id
}

output "public_subnet1c_id" {
  value = aws_subnet.public_1c.id
}

output "private_subnet1a_id" {
  value = aws_subnet.private_1a.id
}

output "private_subnet1c_id" {
  value = aws_subnet.private_1c.id
}
