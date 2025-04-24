variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "nt548-lab01-group10" 
}

variable "vpc_id" {
    description = "The ID of the VPC where route tables will be created."
    type        = string
}

variable "internet_gateway_id" {
    description = "The ID of the internet gateway to attach to the public route table."
    type        = string
}

variable "nat_gateway_id" {
    description = "The ID of the NAT gateway to attach to the private route table."
    type        = string 
}

variable "public_subnet_ids" {
    description = "List of public subnet IDs."
    type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs."
    type        = list(string)
}