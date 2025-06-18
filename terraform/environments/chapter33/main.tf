module "network" {
  source = "../../modules/network"
  env    = var.env
}

module "ec2" {
  source             = "../../modules/ec2"
  env                = var.env
  key_name           = var.key_name
  vpc_id             = module.network.vpc_id
  public_subnet1a_id = module.network.public_subnet1a_id
  SSHlocation        = var.SSHlocation
}

module "rds" {
  source = "../../modules/rds"
  env    = var.env
  private_subnet_list = [
    module.network.private_subnet1a_id,
    module.network.private_subnet1c_id
  ]
  DBusername = var.DBusername
  DBpassword = var.DBpassword
  vpc_id     = module.network.vpc_id
  ec2_sg     = module.ec2.ec2_sg
}

module "alb" {
  source = "../../modules/alb"
  vpc_id = module.network.vpc_id
  public_subnet1a_id = module.network.public_subnet1a_id
  public_subnet1c_id = module.network.public_subnet1c_id
  env = var.env
  instance_main_id = module.ec2.instance_main_id
}

module "monitoring" {
  source = "../../modules/monitoring"
  alert_email = var.alert_email
  instance_main_id = module.ec2.instance_main_id
}

module "waf" {
  source = "../../modules/waf"
  env = var.env
  alb_arn = module.alb.alb_main_arn
  sns_topic_arn = module.monitoring.sns_topic_arn
}