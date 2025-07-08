run "check_alb" {
  command = plan

  module {
    source = "../../modules/alb"
  }

  variables {
    vpc_id             = "vpc-0123456789abctest"
    public_subnet1a_id = "subnet-012345678901test1"
    public_subnet1c_id = "subnet-012345678901test2"
    instance_main_id   = "i-01234567890123456"
  }

  assert {
    condition     = aws_lb.main.internal == false
    error_message = "ロードバランサがプライベートになっています"
  }
  assert {
    condition     = aws_lb.main.load_balancer_type == "application"
    error_message = "ロードバランサのタイプがアプリケーションになっていません"
  }
  assert {
    condition     = aws_lb.main.ip_address_type == "ipv4"
    error_message = "ロードバランサのIPアドレスタイプがipv4になっていません"
  }
}

run "check_ec2" {
  command = plan

  module {
    source = "../../modules/ec2"
  }

  variables {
    vpc_id             = "vpc-0123456789abcdef0"
    ssh_location       = "0.0.0.0/0"
    key_name           = "AWSkey"
    public_subnet1a_id = "subnet-01234567890ftest1"
    public_subnet1c_id = "subnet-01234567890ftest2"
    env                = "test"
  }

  assert {
    condition     = aws_instance.main.ami == "ami-05206bf8aecfc7ae6"
    error_message = "EC2AMIが正しくありません"
  }
  assert {
    condition     = aws_instance.main.instance_type == "t2.micro"
    error_message = "EC2インスタンスタイプが相違しています"
  }
}

run "check_monitoring" {
  command = plan

  module {
    source = "../../modules/monitoring"
  }

  variables {
    instance_main_id = "i-01234567890123456"
    alert_email      = "test@example.com"
  }

  assert {
    condition     = aws_sns_topic.alarm_topic.name == "ALARM"
    error_message = "SNSトピック名が相違しています"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.high_cpu_alarm.alarm_name == "high-cpu-alarm"
    error_message = "アラーム名が相違しています"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.high_cpu_alarm.metric_name == "CPUUtilization"
    error_message = "metric_nameが相違しています"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.high_cpu_alarm.namespace == "AWS/EC2"
    error_message = "CloudWatchアラームの名前空間が相違しています"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.high_cpu_alarm.statistic == "Average"
    error_message = "CloudWatchアラームのstatisticが相違しています"
  }
}

run "check_network" {
  command = plan

  module {
    source = "../../modules/network"
  }

  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPCのCIDRブロックが正しくありません"
  }

  assert {
    condition     = aws_subnet.public_1a.cidr_block == "10.0.1.0/24"
    error_message = "パブリックサブネット1aのCIDRブロックが正しくありません"
  }

  assert {
    condition     = aws_subnet.public_1a.availability_zone == "ap-northeast-1a"
    error_message = "パブリックサブネット1aのAZが正しくありません"
  }

  assert {
    condition     = aws_subnet.public_1c.cidr_block == "10.0.2.0/24"
    error_message = "パブリックサブネット1cのCIDRブロックが正しくありません"
  }

  assert {
    condition     = aws_subnet.public_1c.availability_zone == "ap-northeast-1c"
    error_message = "パブリックサブネット1cのAZが正しくありません"
  }

  assert {
    condition     = aws_subnet.private_1a.cidr_block == "10.0.3.0/24"
    error_message = "プライベートサブネット1aのCIDRブロックが正しくありません"
  }

  assert {
    condition     = aws_subnet.private_1a.availability_zone == "ap-northeast-1a"
    error_message = "プライベートサブネット1aのAZが正しくありません"
  }

  assert {
    condition     = aws_subnet.private_1c.cidr_block == "10.0.4.0/24"
    error_message = "プライベートサブネット1cのCIDRブロックが正しくありません"
  }

  assert {
    condition     = aws_subnet.private_1c.availability_zone == "ap-northeast-1c"
    error_message = "プライベートサブネット1cのAZが正しくありません"
  }
}

run "check_rds" {
  command = plan

  module {
    source = "../../modules/rds"
  }

  variables {
    private_subnet_list = ["subnet-012345678901test3", "subnet-012345678901test4"]
    vpc_id              = "vpc-0123456789abcdef0"
    ec2_sg              = "sg-012345678901test1"
  }

  assert {
    condition     = aws_db_instance.main.instance_class == "db.t3.micro"
    error_message = "RDSのインスタンスクラスが正しくありません"
  }

  assert {
    condition     = aws_db_instance.main.engine == "mysql"
    error_message = "DBエンジンが相違しています"
  }

  assert {
    condition     = aws_db_instance.main.storage_type == "gp2"
    error_message = "DBのストレージタイプが相違しています"
  }

}

run "check_waf" {
  command = plan

  module {
    source = "../../modules/waf"
  }

  variables {
    alb_arn       = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:loadbalancer/app/test-alb/0123456789012345"
    sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:alarm-topic"
  }

  assert {
    condition     = aws_wafv2_web_acl.waf.scope == "REGIONAL"
    error_message = "WAFを適用する対象の指定が相違しています"
  }
}
