variable "project_name" {
  description = "Project name for tagging AWS resources."
  type        = string
  default     = "nt548-lab01-group10"
}

variable "region" {
  description = "AWS region for deployment."
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["192.168.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = ["192.168.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones."
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "allowed_ssh_cidr" {
  description = "List of CIDR blocks allowed to SSH into the public EC2 instance."
  type        = list(string)
  default     = ["14.191.75.180/32"]
}

variable "create_new_keypair" {
  description = "Whether to create a new SSH key pair or use an existing one."
  type        = bool
  default     = false
}

variable "existing_key_name" {
  description = "Name of the existing SSH key pair if create_new_keypair is set to false."
  type        = string
  default     = "nt548-lab01-group10-key"
}

variable "instances_configuration" {
  description = "Configuration list for EC2 instances."
  type = list(object({
    name                    = string
    ami                     = string
    instance_type           = string
    subnet_id               = string
    vpc_security_group_ids  = list(string)
    key_name                = optional(string)
    user_data_file          = optional(string, null)
    associate_elastic_ip    = bool
    root_block_device = optional(object({
      volume_size = number
      volume_type = string
    }))
    tags                    = map(string)
  }))
}
