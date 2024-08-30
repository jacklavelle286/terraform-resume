# vpc and subnets

module "app_vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name = "App-VPC"
}

module "private_subnet_1" {
  source = "./modules/subnet"
  subnet_cidr_block = "10.0.1.0/24"
  subnet_name = "Private-1-App-VPC"
  vpc_id = module.app_vpc.vpc_id
}


module "private_subnet_2" {
  source = "./modules/subnet"
  subnet_cidr_block = "10.0.2.0/24"
  subnet_name = "Private-2-App-VPC"
  vpc_id = module.app_vpc.vpc_id
}

module "main_route_table" {
  source = "./modules/route_table"
  vpc_id = module.app_vpc.vpc_id
  cidr_block = module.app_vpc.vpc_cidr_block
  gateway_id = "local"
}
