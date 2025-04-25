# --- Terraform/examples/security-group_test/main.tf ---

# Define variables using outputs from previous tests
variable "test_vpc_id" {
  description = "ID of the VPC to use for security group testing"
  type        = string
  default     = "vpc-0219fa4fbf4ab53ba"  # Lấy từ output của vpc_test
}
variable "test_allowed_ssh_cidr" {
    description = "The CIDR block to allow SSH access from testingtesting"
    type        = list(string)
    default     = ["14.191.75.180/32"]  # IP Public từ curl https://api.ipify.org
}

# Call the security-group module
module "security_group_test_instance" {
  source = "../../modules/security-group"

  # Cung cấp các giá trị đầu vào cho test
  project_name    = "nt548-lab01-group10group10-test"
  vpc_id          = var.test_vpc_id
}

# Define outputs để xem kết quả test
output "test_public_security_group_id" {
  description = "ID of the public security group created during testing"
  value       = module.security_group_test_instance.public_security_group_id
}

output "test_private_security_group_id" {
  description = "ID of the private security group created during testing"
  value       = module.security_group_test_instance.private_security_group_id
}

output "test_allowed_ssh_cidr" {
  description = "CIDR blocks allowed SSH access"
  value       = var.test_allowed_ssh_cidr
}