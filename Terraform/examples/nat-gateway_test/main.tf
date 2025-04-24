# Define placeholder variables for required IDs (replace with actual IDs for a real test)
variable "test_public_subnet_id" {
  description = "ID of an existing public subnet for testing."
  type        = string
  default     = "subnet-0fa5b292ca7500cd5"
  
}

variable "test_internet_gateway_id" {
  description = "ID of an existing Internet Gateway for testing."
  type        = string
  default     = "igw-0288df6c3040f2306"
}

# Call the nat-gateway module
module "nat_gateway_test_instance" {
  source = "../../modules/nat-gateway"

  # --- Provide input values for this test ---
  project_name            = "nt548-lab01-group10" # Optional: override default project name for test
  public_subnet_id        = var.test_public_subnet_id
  vpc_internet_gateway_id = var.test_internet_gateway_id # Required by depends_on in the module
}

# --- Define outputs to view results after apply ---
output "test_nat_gateway_id" {
  description = "ID of the NAT Gateway created during the test."
  value       = module.nat_gateway_test_instance.nat_gateway_id
}

output "test_nat_eip_id" {
  description = "ID of the Elastic IP created for the NAT Gateway."
  value       = module.nat_gateway_test_instance.nat_eip_id
}

output "test_nat_eip_public_ip" {
  description = "Public IP address of the Elastic IP."
  value       = module.nat_gateway_test_instance.nat_eip_public_ip
}