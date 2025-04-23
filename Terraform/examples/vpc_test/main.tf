# --- Terraform/examples/vpc_test/main.tf ---

# Gọi module vpc từ thư mục modules nằm cách đây 2 cấp thư mục
module "vpc_test_instance" {
  # Đường dẫn tương đối chính xác từ đây đến module vpc
  source = "../../modules/vpc"

  # --- Cung cấp các giá trị đầu vào cho lần test này ---

  project_name = "nt548-lab01-group10"
  vpc_cidr     = "192.168.0.0/16"

  public_subnet_cidrs  = ["192.168.1.0/24"]
  private_subnet_cidrs = ["192.168.2.0/24"]
  availability_zones  = ["ap-southeast-1a"]
}

# --- (Tùy chọn) Định nghĩa các output để xem kết quả sau khi apply ---
output "test_vpc_id" {
  description = "ID của VPC được tạo ra trong quá trình test"
  value       = module.vpc_test_instance.vpc_id
}

output "test_vpc_cidr_block" {
  description = "CIDR block của VPC được tạo ra trong quá trình test"
  value       = module.vpc_test_instance.vpc_cidr_block
}

output "test_public_subnet_ids" {
  description = "Danh sách ID của các public subnet được tạo ra trong quá trình test"
  value       = module.vpc_test_instance.public_subnet_ids
}

output "test_private_subnet_ids" {
  description = "Danh sách ID của các private subnet được tạo ra trong quá trình test"
  value       = module.vpc_test_instance.private_subnet_ids
}

output "test_igw_id" {
  description = "ID của Internet Gateway được tạo ra trong quá trình test"
  value       = module.vpc_test_instance.internet_gateway_id
}

output "test_default_sg_id" {
  description = "ID của Default Security Group cho VPC test"
  value       = module.vpc_test_instance.default_security_group_id
}