output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The list of public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "The list of private subnet IDs."
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = module.vpc.internet_gateway_id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_id" {
  description = "The ID of the private route table."
  value       = module.route_tables.private_route_table_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = module.nat_gateway.nat_gateway_id
}

output "public_security_group_id" {
  description = "The ID of the public EC2 security group."
  value       = module.security_group.public_security_group_id
}

output "private_security_group_id" {
  description = "The ID of the private EC2 security group."
  value       = module.security_group.private_security_group_id
}

output "instance_ids" {
  description = "The IDs of the EC2 instances."
  value       = module.ec2.instance_ids
}

output "instance_public_ips" {
  description = "The public IPs or Elastic IPs of the EC2 instances."
  value       = module.ec2.instance_public_ips
}

output "instance_private_ips" {
  description = "The private IPs of the EC2 instances."
  value       = module.ec2.instance_private_ips
}

output "elastic_ip_ids" {
  description = "The allocation IDs of the Elastic IP addresses."
  value       = module.ec2.elastic_ip_ids
}

output "key_pair_name" {
  description = "The name of the SSH key pair used by EC2 instances."
  value       = module.ec2.key_pair_name
}

output "key_secret_name" {
  description = "The name of the AWS Secrets Manager secret containing the private key."
  value       = module.ec2.key_secret_name
}
