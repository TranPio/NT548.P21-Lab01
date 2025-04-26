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
      name                    = "public-instance-1"
      ami                     = var.ami
      instance_type           = "t2.micro"
      subnet_id               = module.vpc_module.public_subnet_ids[0]
      vpc_security_group_ids  = [module.security_group_module.public_security_group_id]
      key_name                = null
      user_data_file          = var.user_data_file
      associate_elastic_ip    = true
      root_block_device = {
        volume_size           = 8
        volume_type           = "gp2"
      }
      tags = {
        Name = "public-instance"
      }
    },
    {
      name                    = "private-instance-1"
      ami                     = var.ami
      instance_type           = "t2.micro"
      subnet_id               = module.vpc_module.private_subnet_ids[0]
      vpc_security_group_ids  = [module.security_group_module.private_security_group_id]
      key_name                = null
      user_data_file          = null
      associate_elastic_ip    = false
      root_block_device = {
        volume_size           = 8
        volume_type           = "gp2"
      }
      tags = {
        Name = "private-instance"
      }
    }
  ]
}
