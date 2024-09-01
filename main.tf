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


