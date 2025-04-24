output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = aws_subnet.public_subnet[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks."
  value       = aws_subnet.public_subnet[*].cidr_block
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = aws_subnet.private_subnet[*].id
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks."
  value       = aws_subnet.private_subnet[*].cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.igw.id
}

output "default_security_group_id" {
  description = "The ID of the default security group."
  value       = aws_default_security_group.default_sg.id
}