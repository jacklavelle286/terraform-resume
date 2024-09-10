# vpc and subnets

module "cv-app_vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name = "CV-App-VPC"
}

# private vpc resources

module "private_subnet_1" {
  source = "./modules/subnet"
  subnet_cidr_block = "10.0.1.0/24"
  subnet_name = "Private-1-CV-App-VPC"
  vpc_id = module.cv-app_vpc.vpc_id
  subnet_az = "us-east-1a"
}


module "private_subnet_2" {
  source = "./modules/subnet"
  subnet_cidr_block = "10.0.2.0/24"
  subnet_name = "Private-2-CV-App-VPC"
  vpc_id = module.cv-app_vpc.vpc_id
  subnet_az = "us-east-1b"
}

module "private_route_table" {
  source = "./modules/route_table"
  vpc_id = module.cv-app_vpc.vpc_id
  cidr_block = module.cv-app_vpc.vpc_cidr_block
  gateway_id = "local"
}


module "private_subnet_1_rtb_assoc" {
  source = "./modules/route_table_association"
  route_table_id = module.private_route_table.route_table_id
  subnet_id = module.private_subnet_1.subnet_id
}

module "private_subnet_2_rtb_assoc" {
  source = "./modules/route_table_association"
  route_table_id = module.private_route_table.route_table_id
  subnet_id = module.private_subnet_2.subnet_id
}


# public vpc resources
 

module "internet_gateway" {
 source = "./modules/internet_gateway"
} 

module "igw_attachment" {
 source = "./modules/internet_gateway_attachment"
 vpc_id = module.cv-app_vpc.vpc_id
 internet_gateway_id = module.internet_gateway.igw_id
}

module "public_subnet_1" {
  source = "./modules/subnet"
  subnet_cidr_block = "10.0.3.0/24"
  vpc_id = module.cv-app_vpc.vpc_id
  subnet_name = "Public-1-CV-App-VPC"
  subnet_az = "us-east-1a"
}

module "public_subnet_2" {
  source = "./modules/subnet"
  subnet_cidr_block = "10.0.4.0/24"
  vpc_id = module.cv-app_vpc.vpc_id
  subnet_name = "Public-2-CV-App-VPC"
  subnet_az = "us-east-1b"
}

module "public_route_table" {
  source = "./modules/route_table"
  gateway_id = module.internet_gateway.igw_id
  vpc_id = module.cv-app_vpc.vpc_id
  cidr_block = "0.0.0.0/0"
}

module "public_subnet_1_rtb_assoc" {
  source = "./modules/route_table_association"
  route_table_id = module.public_route_table.route_table_id
  subnet_id = module.public_subnet_1.subnet_id
}

module "public_subnet_2_rtb_assoc" {
  source = "./modules/route_table_association"
  route_table_id = module.public_route_table.route_table_id
  subnet_id = module.public_subnet_2.subnet_id
}

# security groups and rules


module "alb_sg" {
  source = "./modules/security_group"
  security_group_name = "alb-security-group"
  vpc_id = module.cv-app_vpc.vpc_id
}

module "inbound_alb_sg_rule_https_from_web" {
  source = "./modules/security_group_rules/ingress"
  from_port = 443
  to_port = 443
  security_group_id = module.alb_sg.sg_id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  inbound_sg_id = null
}


module "app_sg" {
  source = "./modules/security_group"
  security_group_name = "app-security-group"
  vpc_id = module.cv-app_vpc.vpc_id
}


module "inbound_app_sg_rule_http_from_alb" {
  source            = "./modules/security_group_rules/ingress"
  from_port         = 80
  to_port           = 80
  security_group_id = module.app_sg.sg_id
  ip_protocol       = "tcp"
  inbound_sg_id     = module.alb_sg.sg_id
  cidr_ipv4         = null  # Set to null since inbound_sg_id is used
}


# app resources


module "app_launch_template" {
  source = "./modules/launch_template"
  app_image_id = var.latest_app_image_id
  security_group_ids = [
   module.app_sg.sg_id
  ]
  launch_template_name = "app_launch_template"
  instance_type = "t2.micro"

}

module "app_autoscaling_group" {
  source = "./modules/autoscaling_group"
  launch_template_id = module.app_launch_template.launch_template_id
  vpc_zone_identifier = [module.private_subnet_1.subnet_id, module.private_subnet_2.subnet_id]
  tg_arn = [module.target_group.target_group_arn]
}


module "app_alb" {
 source = "./modules/application_load_balancer"
 security_groups = [module.alb_sg.sg_id]
 alb_subnets = [ 
  module.private_subnet_1.subnet_id,
  module.private_subnet_2.subnet_id 
  ]
 alb_security_groups = [module.app_sg.sg_id]
 alb_name = "App-ALB"

}


module "target_group" {
  source = "./modules/target_group"
  port = 80
  vpc_id = module.cv-app_vpc.vpc_id
  protocol = "TCP"
  aws_lb_tg_name = "app-target-group"
}

module "alb_listener" {
  source = "./modules/alb_listener"
  lb_arn = module.app_alb.alb_arn
  cert_arn = module.cert.acm_cert_arn
  tg_arn = module.target_group.target_group_arn
}

module "cert" {
  source = "./modules/cert"
  domain_name = "jackaws.com"
}


module "cert_validation" {
  source                = "./modules/cert_validation"
  certificate_arn       = module.cert.acm_cert_arn
  validation_record_fqdns = module.route53_dns_validation.record_fqdns
}


module "route53_dns_validation" {
  source = "./modules/route53_dns_validation"
  domain_validation_options = module.cert.domain_validation_options
  zones = {
    "jackaws.com" = "Z04076261DWCVKSK9O6HF"
  }
}


# A Record for jackaws.com (naked domain)
resource "aws_route53_record" "example_com_root" {
  zone_id = "Z04076261DWCVKSK9O6HF"
  name    = "jackaws.com"
  type    = "A"

  alias {
    name                   = module.app_alb.alb_dns_name
    zone_id                = module.app_alb.alb_zone_id
    evaluate_target_health = true
  }
}

# A Record for www.jackaws.com (www subdomain)
resource "aws_route53_record" "example_com_www" {
  zone_id = "Z04076261DWCVKSK9O6HF"  
  name    = "www.jackaws.com"
  type    = "A"

  alias {
    name                   = module.app_alb.alb_dns_name
    zone_id                = module.app_alb.alb_zone_id
    evaluate_target_health = true
  }
}
