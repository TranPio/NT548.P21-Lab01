variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "nt548-lab01-group10" 
  
}

variable "public_subnet_id" {
    description = "The ID of the public subnet."
    type        = string
}

variable "vpc_internet_gateway_id" {
    description = "The ID of the Internet Gateway."
    type        = string
}