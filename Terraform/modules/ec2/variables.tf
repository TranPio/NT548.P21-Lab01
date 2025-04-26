variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "nt548-lab01-group10" 
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}

# Thêm biến để quyết định có tạo key mới hay không
variable "create_new_keypair" {
  description = "Whether to create a new key pair or use an existing one"
  type        = bool
  default     = false
}

# Thêm biến cho tên key-pair hiện có nếu không tạo mới
variable "existing_key_name" {
  description = "Name of existing key pair to use if create_new_keypair is false"
  type        = string
  default     = "nt548-lab01-group10-key"
}

variable "instance_configuration" {
    description = "A list of objects defining the configuration for EC2 instance."
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
            volume_size           = number
            volume_type           = string
        }))
        tags                    = map(string) 
    }))
    default = [
        #Public instance 
    {
        name                    = "public-instance-1"
        ami                     = "ami-0c1907b6d738188e5" # Ubuntu 22.04
        instance_type           = "t2.micro"
        subnet_id               = "subnet-0fa5b292ca7500cd5" 
        vpc_security_group_ids  = ["sg-062c6a8eca5edcaf6"]
        key_name                = "nt548-lab01-group10-key-1" 
        user_data_file          = "user-data.sh"
        associate_elastic_ip    = true
        root_block_device = {
            volume_size           = 8
            volume_type           = "gp2"
        }
         tags                    = {
            Name = "public-instance"
        }
    },
    #Private instance
    {
        name                   = "private-instance-1"
        ami                    = "ami-0c1907b6d738188e5" # Ubuntu 22.04
        instance_type          = "t2.micro"
        subnet_id              = "subnet-0de3227231cb98ede"
        vpc_security_group_ids = [ "sg-085051cac0edf57f0" ]
        key_name               = "nt548-lab01-group10-key-1"
        user_data_file         = null
        associate_elastic_ip   = false
        root_block_device = {
            volume_size           = 8
            volume_type           = "gp2"
        }
         tags                    = {
            Name = "private-instance"
        }
    }]
}