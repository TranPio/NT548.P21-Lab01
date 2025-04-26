terraform {
  backend "s3" {
    bucket         = "nt548-terraform"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform_table"
  }
}

provider "aws" {
  region = var.region
}

# VPC
module "vpc" {
  source                = "./modules/vpc"
  project_name          = var.project_name
  region                = var.region
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
}

# NAT Gateway
module "nat_gateway" {
  source                  = "./modules/nat-gateway"
  project_name            = var.project_name
  public_subnet_id        = module.vpc.public_subnet_ids[0]
  vpc_internet_gateway_id = module.vpc.internet_gateway_id
}

# Route Tables
module "route_tables" {
  source              = "./modules/route-tables"
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
}

# Security Groups
module "security_group" {
  source           = "./modules/security-group"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# EC2 Instances
module "ec2" {
  source                  = "./modules/ec2"
  project_name            = var.project_name
  aws_region              = var.region
  create_new_keypair      = var.create_new_keypair
  existing_key_name       = var.existing_key_name
  instance_configuration  = var.instances_configuration
}
