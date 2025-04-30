variable "project_name" {
  type        = string
  default     = "nt548-lab01-group10"
  description = "Project name for tagging AWS resources."
}

variable "region" {
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["192.168.1.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["192.168.2.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "allowed_ssh_cidr" {
  type        = list(string)
  default     = ["14.191.75.180/32"]
}

variable "create_new_keypair" {
  type        = bool
  default     = true
}

variable "existing_key_name" {
  type        = string
  default     = "nt548-lab01-group10-key-1"
}

variable "ami" {
  type        = string
  default     = "ami-0c1907b6d738188e5" # Ubuntu 22.04 LTS
}

variable "user_data_file" {
  type        = string
  default     = "user-data.sh"
}

variable "instance_configuration" {
  type = list(object({
    name                    = string
    ami                     = string
    instance_type           = string
    subnet_id               = string
    vpc_security_group_ids  = list(string)
    key_name                = string
    user_data_file          = string
    associate_elastic_ip    = bool
    root_block_device = object({
      volume_size = number
      volume_type = string
    })
    tags = map(string)
  }))
  default = [
    {
      name                    = "public-instance-1"
      ami                     = "ami-0c1907b6d738188e5"
      instance_type           = "t2.micro"
      subnet_id               = "" # Sẽ được gán trong main.tf
      vpc_security_group_ids  = [] # Sẽ được gán trong main.tf
      key_name                = null
      user_data_file          = "user-data.sh"
      associate_elastic_ip    = true
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name = "public-instance"
      }
    },
    {
      name                    = "private-instance-1"
      ami                     = "ami-0c1907b6d738188e5"
      instance_type           = "t2.micro"
      subnet_id               = "" # Sẽ được gán trong main.tf
      vpc_security_group_ids  = [] # Sẽ được gán trong main.tf
      key_name                = null
      user_data_file          = null
      associate_elastic_ip    = false
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name = "private-instance"
      }
    }
  ]
}