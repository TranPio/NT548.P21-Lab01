variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "nt548-lab01-group10" 
}

variable "region" {
  description = "The AWS region to deploy the resources in."
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
    default     = [ "192.168.1.0/24" ]
}

variable "private_subnet_cidrs" {
    description = "List of CIDR blocks for private subnets."
    type        = list(string)
    default     = [ "192.168.2.0/24" ]
}

variable "availability_zones" {
    description = "List of availability zones to use."
    type        = list(string)
    default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  
}