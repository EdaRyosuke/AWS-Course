# ALB用セキュリティグループ
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
}

# ロードバランサ
resource "aws_lb" "main" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    var.public_subnet1a_id,
    var.public_subnet1c_id
  ]
  ip_address_type = "ipv4"
  tags = {
    Name = "${var.env}-alb"
  }
}

# ターゲットグループ
resource "aws_lb_target_group" "alb_target_group" {
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = 8080
  protocol         = "HTTP"
  vpc_id           = var.vpc_id
  tags = {
    Name = "${var.env}-alb-target-group"
  }

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200,301"
  }
}

# ターゲットグループ用アタッチメント
resource "aws_lb_target_group_attachment" "target_ec2" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.instance_main_id
}

# ALBリスナー
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}