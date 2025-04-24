
# Define variables using outputs from previous tests as defaults
variable "test_vpc_id" {
  description = "ID of the VPC created in vpc_test."
  type        = string
  default     = "vpc-0219fa4fbf4ab53ba"
}

variable "test_internet_gateway_id" {
  description = "ID of the Internet Gateway created in vpc_test."
  type        = string
  default     = "igw-0288df6c3040f2306"
}

variable "test_nat_gateway_id" {
  description = "ID of the NAT Gateway created in nat-gateway_test."
  type        = string
  default     = "nat-00e28fafd761d1f13"
}

variable "test_public_subnet_ids" {
  description = "List of public subnet IDs created in vpc_test."
  type        = list(string)
  default     = "subnet-0fa5b292ca7500cd5"
}

variable "test_private_subnet_ids" {
  description = "List of private subnet IDs created in vpc_test."
  type        = list(string)
  default     = "subnet-0de3227231cb98ede"
}

# Call the route-tables module
module "route_tables_test_instance" {
  source = "../../modules/route-tables"

  # --- Provide input values for this test ---
  project_name        = "nt548-lab01-group10-test" # Optional: override default project name
  vpc_id              = var.test_vpc_id
  internet_gateway_id = var.test_internet_gateway_id
  nat_gateway_id      = var.test_nat_gateway_id
  public_subnet_ids   = var.test_public_subnet_ids
  private_subnet_ids  = var.test_private_subnet_ids
}

# --- Define outputs to view results after apply ---
output "test_public_route_table_id" {
  description = "ID of the public route table created during the test."
  value       = module.route_tables_test_instance.public_route_table_id
}

output "test_private_route_table_id" {
  description = "ID of the private route table created during the test."
  value       = module.route_tables_test_instance.private_route_table_id
}