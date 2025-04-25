
# Define variables với giá trị lấy từ output của các test trước
variable "test_vpc_id" {
  description = "ID of the VPC created in vpc_test"
  type        = string
  default     = "vpc-0219fa4fbf4ab53ba"
}

variable "test_public_subnet_id" {
  description = "ID of the public subnet created in vpc_test"
  type        = string
  default     = "subnet-0fa5b292ca7500cd5"
}

variable "test_private_subnet_id" {
  description = "ID of the private subnet created in vpc_test"
  type        = string
  default     = "subnet-0de3227231cb98ede"
}

variable "test_public_sg_id" {
  description = "ID of the public security group created in security-group_test"
  type        = string
  default     = "sg-062c6a8eca5edcaf6"
}

variable "test_private_sg_id" {
  description = "ID of the private security group created in security-group_test"
  type        = string
  default     = "sg-085051cac0edf57f0"
}

# Gọi module EC2 để test
module "ec2_test_instance" {
  source = "../../modules/ec2"

  project_name = "nt548-lab01-ec2-test"
  
  # Override default configuration để test với giá trị từ các test trước
  instance_configuration = [
    {
      name                   = "test-public-instance"
      ami                    = "ami-0c1907b6d738188e5" # Ubuntu 22.04
      instance_type          = "t2.micro"
      subnet_id              = var.test_public_subnet_id
      vpc_security_group_ids = [var.test_public_sg_id]
      key_name               = "nt548-lab01-group10-key"
      user_data_file         = null
      associate_elastic_ip   = true
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name        = "test-public-instance"
        Environment = "Test"
      }
    },
    {
      name                   = "test-private-instance"
      ami                    = "ami-0c1907b6d738188e5" # Ubuntu 22.04
      instance_type          = "t2.micro"
      subnet_id              = var.test_private_subnet_id
      vpc_security_group_ids = [var.test_private_sg_id]
      key_name               = "nt548-lab01-group10-key"
      user_data_file         = null
      associate_elastic_ip   = false
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name        = "test-private-instance"
        Environment = "Test" 
      }
    }
  ]
}

# Define outputs để xem kết quả test
output "test_instance_ids" {
  description = "IDs of EC2 instances created in the test"
  value       = module.ec2_test_instance.instance_ids
}

output "test_public_ip" {
  description = "Public IP của public instance"
  value       = module.ec2_test_instance.instance_public_ips["test-public-instance"]
}

output "test_private_ips" {
  description = "Private IPs của tất cả instances"
  value       = module.ec2_test_instance.instance_private_ips
}

output "test_eip_ids" {
  description = "IDs của Elastic IPs được tạo"
  value       = module.ec2_test_instance.elastic_ip_ids
}

output "test_public_instance_id" {
  description = "ID của public instance"
  value       = module.ec2_test_instance.public_instance_id
}

output "test_private_instance_id" {
  description = "ID của private instance"  
  value       = module.ec2_test_instance.private_instance_id
}