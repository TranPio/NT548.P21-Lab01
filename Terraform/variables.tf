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
  default     = "nt548-lab01-group10-key"
}

variable "ami" {
  type        = string
  default     = "ami-0c1907b6d738188e5" # Ubuntu 22.04 LTS
}

variable "user_data_file" {
  type        = string
  default     = "user-data.sh"
}
