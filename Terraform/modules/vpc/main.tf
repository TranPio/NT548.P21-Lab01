
# Tạo local variables để sử dụng trong module
locals {
  project_name = var.project_name
}

#-----------------------------------------------------#
#--------------------Tạo VPC--------------------------#
#-----------------------------------------------------#
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.project_name}-vpc"
  }
}

#-----------------------------------------------------#
#----------------Tạo Public Subnets------------------#
#-----------------------------------------------------#
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.project_name}-public-subnet-${count.index + 1}"
  }
  depends_on = [aws_vpc.vpc] # Đảm bảo VPC được tạo trước
}

#-----------------------------------------------------#
#----------------Tạo Private Subnets-----------------#
#-----------------------------------------------------#
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.project_name}-private-subnet-${count.index + 1}"
  }
  depends_on = [aws_vpc.vpc] # Đảm bảo VPC được tạo trước
}

#-----------------------------------------------------#
#----------------Tạo Internet Gateway-----------------#
#-----------------------------------------------------#
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.project_name}-igw"
  }
  depends_on = [aws_vpc.vpc] # Đảm bảo VPC được tạo trước
}

#-----------------------------------------------------#
#--------------Tạo Default Security Group-------------#
#-----------------------------------------------------#
resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.vpc.id

  #Cho phép mọi traffic ra ngoài (Egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 nghĩa là tất cả các protocol
    cidr_blocks = ["0.0.0.0/0"] # Cho phép tất cả các địa chỉ IP
  }

  #Cho phép traffic bên trong VPC (Ingress)
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1" # Tất cả protocol
    self      = true # Cho phép traffic từ các instance trong cùng một security group
  }

  tags = {
    Name = "${local.project_name}-default-sg"
  }
}