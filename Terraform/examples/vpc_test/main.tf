# --- Terraform/examples/vpc_test/main.tf ---

module "vpc_test_instance" {
  source = "../../modules/vpc"

  project_name         = "nt548-lab01-test"
  availability_zones   = ["ap-southeast-1a"]
}

output "test_vpc_id" {
  description = "ID of the VPC created during the test."
  value       = module.vpc_test_instance.vpc_id
}

output "test_vpc_cidr_block" {
  description = "CIDR block of the VPC created during the test."
  value       = module.vpc_test_instance.vpc_cidr_block
}

output "test_public_subnet_ids" {
  description = "List of public subnet IDs created during the test."
  value       = module.vpc_test_instance.public_subnet_ids
}

output "test_public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks created during the test."
  value       = module.vpc_test_instance.public_subnet_cidrs
}

output "test_private_subnet_ids" {
  description = "List of private subnet IDs created during the test."
  value       = module.vpc_test_instance.private_subnet_ids
}

output "test_private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks created during the test."
  value       = module.vpc_test_instance.private_subnet_cidrs
}

output "test_igw_id" {
  description = "ID of the Internet Gateway created during the test."
  value       = module.vpc_test_instance.internet_gateway_id
}

output "test_default_sg_id" {
  description = "ID of the default security group created during the test."
  value       = module.vpc_test_instance.default_security_group_id
}