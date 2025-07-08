# DBサブネットグループ
resource "aws_db_subnet_group" "DB_subnet_group" {
  subnet_ids = var.private_subnet_list
  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

# RDSセキュリティグループ
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
  egress = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    description      = "Allow all outbound traffic"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
  tags = {
    Name = "${var.env}-rds-sg"
  }
}

resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.ec2_sg
}

# RDS
resource "aws_db_instance" "main" {
  instance_class             = "db.t3.micro"
  allocated_storage          = 10
  engine                     = "mysql"
  engine_version             = "8.0"
  storage_type               = "gp2"
  db_name                    = "awsstudy"
  username                   = var.DBusername
  password                   = var.DBpassword
  auto_minor_version_upgrade = false
  backup_retention_period    = 7
  db_subnet_group_name       = aws_db_subnet_group.DB_subnet_group.name
  multi_az                   = false
  publicly_accessible        = false
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  skip_final_snapshot        = true
}
