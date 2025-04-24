variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "nt548-lab01-group10" 
}

variable "instance_configuration" {
    description = "A list of objects defining the configuration for EC2 instance."
    type = list(object({
        name                    = string
        ami                     = string
        instance_type           = string
        subnet_id               = string
        vpc_security_group_ids  = list(string)
        key_name                = string
        associate_elastic_ip    = bool 
        tags                    = map(string) 
    }))
    default = [{
        name                   = "public-instance-1"
        ami                     = "ami-0c1907b6d738188e5" # Ubuntu 22.04
        instance_type           = "t2.micro"
        root_block_device = {
            volume_size           = 8
            volume_type           = "gp2"
        }
         tags                    = {
            Name = "public-instance"
        }
        subnet_id               = "subnet-0bb1c79de3EXAMPLE" # Replace with your subnet ID
        vpc_security_group_ids  = ["sg-0bb1c79de3EXAMPLE"] # Replace with your security group ID
        key_name                = "my-key-pair" # Replace with your key pair name
        associate_elastic_ip    = true
    },
    {
        name                   = "private-instance-1"
        ami                     = "ami-0c1907b6d738188e5" # Ubuntu 22.04
        instance_type           = "t2.micro"
        root_block_device = {
            volume_size           = 8
            volume_type           = "gp2"
        }
         tags                    = {
            Name = "private-instance"
        }
        subnet_id               = "subnet-0bb1c79de3EXAMPLE" # Replace with your subnet ID
        vpc_security_group_ids  = ["sg-0bb1c79de3EXAMPLE"] # Replace with your security group ID
        key_name                = "my-key-pair" # Replace with your key pair name
        associate_elastic_ip    = false
    }]
  
}