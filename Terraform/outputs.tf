output "vpc_id" {
  value = module.vpc_module.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc_module.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc_module.private_subnet_ids
}

output "internet_gateway_id" {
  value = module.vpc_module.internet_gateway_id
}

output "nat_gateway_id" {
  value = module.nat_gateway_module.nat_gateway_id
}

output "public_route_table_id" {
  value = module.route_table_module.public_route_table_id
}

output "private_route_table_id" {
  value = module.route_table_module.private_route_table_id
}

output "public_security_group_id" {
  value = module.security_group_module.public_security_group_id
}

output "private_security_group_id" {
  value = module.security_group_module.private_security_group_id
}

output "instance_ids" {
  value = module.ec2_module.instance_ids
}

output "instance_public_ips" {
  value = module.ec2_module.instance_public_ips
}

output "instance_private_ips" {
  value = module.ec2_module.instance_private_ips
}

output "elastic_ip_ids" {
  value = module.ec2_module.elastic_ip_ids
}

output "key_pair_name" {
  value = module.ec2_module.key_pair_name
}

output "key_secret_name" {
  value = module.ec2_module.key_secret_name
}
