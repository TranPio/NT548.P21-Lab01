locals {
  project_name = var.project_name
}

#-------------------------------------------#
#-------------Public Route Table------------#
#-------------------------------------------#
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  #Route mặc định (0.0.0.0/0) đi ra Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${local.project_name}-public-rt"
  }
}
#------------------------------------------#
#------Associate Public Route Table--------#
#------------------------------------------#
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(var.public_subnet_ids)
  subnet_id      = element(var.public_subnet_ids, count.index)
  route_table_id = aws_route_table.public_rt.id
}

#-------------------------------------------#
#-------------Private Route Table-----------#
#-------------------------------------------#
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  #Route mặc định (0.0.0.0/0) đi ra NAT Gateway
  route = {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${local.project_name}-private-rt"
  }
}

#--------------------------------------------#
#-------Associate Private Route Table--------#
#--------------------------------------------#
resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(var.private_subnet_ids)
  subnet_id      = element(var.private_subnet_ids, count.index)
  route_table_id = aws_route_table.private_rt.id 
}