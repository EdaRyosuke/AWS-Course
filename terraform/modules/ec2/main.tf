#EC2セキュリティグループ
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_location]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
resource "aws_instance" "main" {
  ami                         = "ami-05206bf8aecfc7ae6"
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet1a_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "${var.env}-ec2"
  }
}

resource "aws_instance" "sub" {
  ami                         = "ami-05206bf8aecfc7ae6"
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet1c_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "${var.env}-sub-ec2"
  }
}
