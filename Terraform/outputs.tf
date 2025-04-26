output "vpc_id" {
  description = "ID của VPC đã tạo"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID của public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID của private subnet"
  value       = module.vpc.private_subnet_id
}

output "internet_gateway_id" {
  description = "ID của Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID của NAT Gateway"
  value       = module.nat_gateway.nat_gateway_id
}

output "nat_gateway_elastic_ip" {
  description = "Elastic IP của NAT Gateway"
  value       = module.nat_gateway.elastic_ip
}

output "public_security_group_id" {
  description = "ID của security group cho public instances"
  value       = module.security_group.public_security_group_id
}

output "private_security_group_id" {
  description = "ID của security group cho private instances"
  value       = module.security_group.private_security_group_id
}

output "public_route_table_id" {
  description = "ID của public route table"
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_id" {
  description = "ID của private route table"
  value       = module.route_tables.private_route_table_id
}

output "instance_ids" {
  description = "IDs của các EC2 instances"
  value       = module.ec2.instance_ids
}

output "instance_public_ips" {
  description = "Public IPs của các EC2 instances"
  value       = module.ec2.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IPs của các EC2 instances"
  value       = module.ec2.instance_private_ips
}

output "elastic_ip_ids" {
  description = "IDs của các Elastic IPs"
  value       = module.ec2.elastic_ip_ids
}

output "public_instance_id" {
  description = "ID của public instance"
  value       = module.ec2.public_instance_id
}

output "private_instance_id" {
  description = "ID của private instance" 
  value       = module.ec2.private_instance_id
}