output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Danh sách Public Subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Danh sách Private Subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = module.route_tables.private_route_table_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.nat_gateway.nat_gateway_id
}

output "public_security_group_id" {
  description = "Public EC2 Security Group ID"
  value       = module.security_group.public_security_group_id
}

output "private_security_group_id" {
  description = "Private EC2 Security Group ID"
  value       = module.security_group.private_security_group_id
}

output "instance_ids" {
  description = "IDs của các EC2 instance"
  value       = module.ec2.instance_ids
}

output "instance_public_ips" {
  description = "Public IPs hoặc Elastic IPs của các EC2 instances"
  value       = module.ec2.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IPs của các EC2 instances"
  value       = module.ec2.instance_private_ips
}

output "elastic_ip_ids" {
  description = "Elastic IP Allocation IDs"
  value       = module.ec2.elastic_ip_ids
}

output "key_pair_name" {
  description = "SSH Key Pair Name"
  value       = module.ec2.key_pair_name
}

output "key_secret_name" {
  description = "Tên Secret Manager chứa Private Key"
  value       = module.ec2.key_secret_name
}
