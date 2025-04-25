variable "project_name" {
    description = "Project name for tagging resources."
    type        = string
    default     = "nt548-lab01-group10" 
}

variable "vpc_id" {
    description = "The ID of the VPC where the security group will be created."
    type        = string
    default     = "vpc-0219fa4fbf4ab53ba"
}

variable "allowed_ssh_cidr" {
    description = "The CIDR block to allow SSH access from."
    type        = list(string)
    default     = ["14.191.75.180/32"]  # IP Public từ curl https://api.ipify.org
}