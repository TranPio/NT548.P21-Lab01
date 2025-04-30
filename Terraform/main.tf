terraform {
  backend "s3" {
    bucket         = "nt548-group10-terraform"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform_table_group10"
  }
}

provider "aws" {
  region = var.region
}

# VPC module
module "vpc_module" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs= var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

# NAT Gateway
module "nat_gateway_module" {
  source                = "./modules/nat-gateway"
  project_name          = var.project_name
  public_subnet_id      = module.vpc_module.public_subnet_ids[0]
  vpc_internet_gateway_id = module.vpc_module.internet_gateway_id
}

# Route Tables
module "route_table_module" {
  source               = "./modules/route-tables"
  project_name         = var.project_name
  vpc_id               = module.vpc_module.vpc_id
  internet_gateway_id  = module.vpc_module.internet_gateway_id
  nat_gateway_id       = module.nat_gateway_module.nat_gateway_id
  public_subnet_ids    = module.vpc_module.public_subnet_ids
  private_subnet_ids   = module.vpc_module.private_subnet_ids
}

# Security Groups
module "security_group_module" {
  source           = "./modules/security-group"
  project_name     = var.project_name
  vpc_id           = module.vpc_module.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# EC2 Instances
module "ec2_module" {
  source             = "./modules/ec2"
  project_name       = var.project_name
  aws_region         = var.region
  create_new_keypair = var.create_new_keypair
  existing_key_name  = var.existing_key_name
  instance_configuration = [
    {
      name                    = var.instance_configuration[0].name
      ami                     = var.instance_configuration[0].ami
      instance_type           = var.instance_configuration[0].instance_type
      subnet_id               = module.vpc_module.public_subnet_ids[0]
      vpc_security_group_ids  = [module.security_group_module.public_security_group_id]
      key_name                = var.instance_configuration[0].key_name
      user_data_file          = var.instance_configuration[0].user_data_file
      associate_elastic_ip    = var.instance_configuration[0].associate_elastic_ip
      root_block_device       = var.instance_configuration[0].root_block_device
      tags                    = var.instance_configuration[0].tags
    },
    {
      name                    = var.instance_configuration[1].name
      ami                     = var.instance_configuration[1].ami
      instance_type           = var.instance_configuration[1].instance_type
      subnet_id               = module.vpc_module.private_subnet_ids[0]
      vpc_security_group_ids  = [module.security_group_module.private_security_group_id]
      key_name                = var.instance_configuration[1].key_name
      user_data_file          = var.instance_configuration[1].user_data_file
      associate_elastic_ip    = var.instance_configuration[1].associate_elastic_ip
      root_block_device       = var.instance_configuration[1].root_block_device
      tags                    = var.instance_configuration[1].tags
    }
  ]
}
