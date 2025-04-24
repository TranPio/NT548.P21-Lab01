locals {
  project_name = var.project_name
}

#-----------------------------------------------------#
#-----------------Tạo Elastic IP----------------------#    
#-----------------------------------------------------#
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${local.project_name}-nat-eip"
  }
}

#-----------------------------------------------------#
#----------------Tạo NAT Gateway----------------------#    
#-----------------------------------------------------#
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${local.project_name}-nat-gw"
  }
    depends_on = [var.vpc_internet_gateway_id] # Đảm bảo Internet Gateway được tạo trước
}