provider "aws" {
  region = var.aws_region
}

# Gọi module VPC để tạo VPC và các subnet
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  region = var.aws_region
  
  # Sửa tên biến cho khớp với định nghĩa trong module vpc
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = [var.public_subnet_cidr]  # Chuyển thành list
  private_subnet_cidrs = [var.private_subnet_cidr]  # Chuyển thành list
  availability_zones = [var.availability_zone]  # Chuyển thành list
}

# Gọi module security-group để tạo các security group cho instance
module "security_group" {
  source = "./modules/security-group"
  
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# Gọi module nat-gateway để tạo NAT Gateway cho private subnet
module "nat_gateway" {
  source = "./modules/nat-gateway"
  
  project_name = var.project_name
  # Bổ sung biến vpc_internet_gateway_id theo định nghĩa trong module nat-gateway
  vpc_internet_gateway_id = module.vpc.internet_gateway_id
  public_subnet_id = module.vpc.public_subnet_id
}

# Gọi module route-tables để cấu hình routing
module "route_tables" {
  source = "./modules/route-tables"
  
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  # Chuyển từ string sang list theo định nghĩa trong module
  public_subnet_ids = [module.vpc.public_subnet_id]
  private_subnet_ids = [module.vpc.private_subnet_id]
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

# Gọi module EC2 để tạo instances
module "ec2" {
  source = "./modules/ec2"
  
  project_name = var.project_name
  
  # Cấu hình chi tiết cho các EC2 instances
  instance_configuration = [
    {
      name = "public-instance"
      ami = var.ami_id
      instance_type = var.instance_type
      subnet_id = module.vpc.public_subnet_id
      vpc_security_group_ids = [module.security_group.public_security_group_id]
      key_name = var.key_name
      user_data_file = null
      associate_elastic_ip = true
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name = "${var.project_name}-public-instance"
        Environment = var.environment
      }
    },
    {
      name = "private-instance"
      ami = var.ami_id
      instance_type = var.instance_type
      subnet_id = module.vpc.private_subnet_id
      vpc_security_group_ids = [module.security_group.private_security_group_id]
      key_name = var.key_name
      user_data_file = null
      associate_elastic_ip = false
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name = "${var.project_name}-private-instance"
        Environment = var.environment
      }
    }
  ]
}