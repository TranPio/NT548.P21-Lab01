locals {
    project_name = var.project_name
}

#---------------------------------------------------------------#
#------------Security Group for Public EC2 Instance-------------#
#---------------------------------------------------------------#
resource "aws_security_group" "public_sg" {
    name        = "${local.project_name}-public-sg"
    description = "Allow SSH inbound from CIDR and all outbound traffic"
    vpc_id      = var.vpc_id

    #Ingress Rule: Allow SSH (Port 22) from allowed IPs
    ingress {
        description = "SSH from allowed IP"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.allowed_ssh_cidr
    }

    #Egress Rule: Allow all outbound traffic
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1" # -1 means all protocols
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "${local.project_name}-public-sg"
    }
}

#----------------------------------------------------------------#
#------------Security Group for Private EC2 Instance-------------#
#----------------------------------------------------------------#
resource "aws_security_group" "private_sg" {
    name        = "${local.project_name}-private-sg"
    description = "Allow SSH inbound from public security group and all outbound traffic"
    vpc_id      = var.vpc_id

    #Ingress Rule: Allow SSH (Port 22) from public security group
    ingress {
        description     = "SSH from public security group"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.public_sg.id]
    }

    #Egress Rule: Allow all outbound traffic
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1" # -1 means all protocols
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "${local.project_name}-private-sg"
    }
}