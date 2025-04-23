variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "nt548-lab01-group10"
}