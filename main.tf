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
  availability_zones = [
   module.private_subnet_1.availability_zone,
   module.private_subnet_2.availability_zone
  ]
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

# microservices

# page counter microservice

module "view_counter_lambda_function_role" {
  source = "./modules/iam_role"
  role_name = "view_counter_execution_role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role.json
  policy_name         = "lambda_execution_policy"
  policy_description  = "Policy for Lambda execution role"
  policy_document     = data.aws_iam_policy_document.lambda_policy.json
}


data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["dynamodb:UpdateItem", "dynamodb:GetItem", "dynamodb:DescribeTable"]
    resources = [module.view_counter_dynamodb.dynamodb_table_arn]
  }
}


module "view_counter_lambda_function" {
  source = "./modules/lambda"  # Path to your module
  role          = module.view_counter_lambda_function_role.role_arn
  function_name = "view_counter_function"
  handler       = "index.handler"
  runtime       = "python3.12"
  source_dir = "./modules/lambda/code/view.py"

  env_map = {
    DynamoDBTableName = module.view_counter_dynamodb.dynamodb_table_name
  }
  create_function_url = true
}

module "view_counter_dynamodb" {
  source = "./modules/dynamodb_table"
  table_name = "view_counter_dynamodb_table"
  dynamodb_attributes = [
    {
      name = "PostID"
      type = "S"
    },
    {
      name = "AuthorID"
      type = "S"
    }
  ]
}