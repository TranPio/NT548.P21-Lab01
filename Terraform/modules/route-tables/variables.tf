variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "nt548-lab01-group10" 
}

variable "vpc_id" {
    description = "The ID of the VPC where route tables will be created."
    type        = string
    default     = "vpc-0219fa4fbf4ab53ba"
}

variable "internet_gateway_id" {
    description = "The ID of the internet gateway to attach to the public route table."
    type        = string
    default     = "igw-0288df6c3040f2306"
}

variable "nat_gateway_id" {
    description = "The ID of the NAT gateway to attach to the private route table."
    type        = string 
    default     = "nat-00e28fafd761d1f13"
}

variable "public_subnet_ids" {
    description = "List of public subnet IDs."
    type        = list(string)
    default     = ["subnet-0fa5b292ca7500cd5"]
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs."
    type        = list(string)
    default     = ["subnet-0de3227231cb98ede"]
}