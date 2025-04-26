locals {
  project_name = var.project_name
  key_pair_name = "${var.project_name}-key-1"
}

# Tìm key pair hiện có nếu không tạo mới
data "aws_key_pair" "existing_key" {
  count = var.create_new_keypair ? 0 : 1
  key_name = var.existing_key_name
}

# Tạo RSA key pair - chỉ khi create_new_keypair = true
resource "tls_private_key" "instance_key" {
  count = var.create_new_keypair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Tạo AWS key pair từ key đã tạo - chỉ khi create_new_keypair = true
resource "aws_key_pair" "instance_key_pair" {
  count = var.create_new_keypair ? 1 : 0
  key_name   = local.key_pair_name
  public_key = tls_private_key.instance_key[0].public_key_openssh
}

# Tạo Secret để lưu private key - chỉ khi create_new_keypair = true
resource "aws_secretsmanager_secret" "instance_key_secret" {
  count = var.create_new_keypair ? 1 : 0
  name        = "${var.project_name}-keypair"
  description = "Private key for EC2 instances"
}

# Lưu private key vào Secret 
resource "aws_secretsmanager_secret_version" "instance_key_version" {
  count = var.create_new_keypair ? 1 : 0
  secret_id     = aws_secretsmanager_secret.instance_key_secret[0].id
  secret_string = tls_private_key.instance_key[0].private_key_pem
}

# Tạo file user data cho việc lấy key từ Secret Manager
data "template_file" "user_data" {
  count = var.create_new_keypair ? 1 : 0
  template = file("${path.module}/user-data.sh")
  
  vars = {
    aws_region = var.aws_region
    secret_id  = var.create_new_keypair ? aws_secretsmanager_secret.instance_key_secret[0].name : ""
    key_name   = local.key_pair_name
  }
}

#-----------------------------------------------------#
#-----------------Tạo EC2 Instances------------------#
#-----------------------------------------------------#
resource "aws_instance" "ec2_instances" {
  count = length(var.instance_configuration)

  # Các thuộc tính instance từ cấu hình
  ami                    = var.instance_configuration[count.index].ami
  instance_type          = var.instance_configuration[count.index].instance_type
  subnet_id              = var.instance_configuration[count.index].subnet_id
  vpc_security_group_ids = var.instance_configuration[count.index].vpc_security_group_ids
  key_name               = var.create_new_keypair ? aws_key_pair.instance_key_pair[0].key_name : var.instance_configuration[count.index].key_name != null ? var.instance_configuration[count.index].key_name : var.existing_key_name
  
  # Tạo public IP cho instance nếu được chỉ định
  associate_public_ip_address = !var.instance_configuration[count.index].associate_elastic_ip

  # User data script nếu có
  user_data = var.create_new_keypair && var.instance_configuration[count.index].user_data_file == null ? data.template_file.user_data[0].rendered : var.instance_configuration[count.index].user_data_file != null ?file(var.instance_configuration[count.index].user_data_file) : null

  # Cấu hình root volume
  dynamic "root_block_device" {
    for_each = var.instance_configuration[count.index].root_block_device != null ? [var.instance_configuration[count.index].root_block_device] : []
    content {
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
      delete_on_termination = true
    }
  }

  # Tags cho instance
  tags = merge(
    var.instance_configuration[count.index].tags,
    {
      Name = "${local.project_name}-${var.instance_configuration[count.index].name}"
    }
  )
}

#-----------------------------------------------------#
#-----------------Elastic IP cho Instance-------------#
#-----------------------------------------------------#
resource "aws_eip" "instance_eips" {
  count = length([for config in var.instance_configuration : config if config.associate_elastic_ip])

  domain = "vpc"

  tags = {
    Name = "${local.project_name}-eip-${var.instance_configuration[count.index].name}"
  }
}

#-----------------------------------------------------#
#-------------Associate EIP với Instance--------------#
#-----------------------------------------------------#
resource "aws_eip_association" "eip_assoc" {
  count = length([for config in var.instance_configuration : config if config.associate_elastic_ip])

  # Lấy instance_id từ resource instance đã tạo
  # Cần lọc instances để lấy đúng instance cần gắn EIP
  instance_id = [
    for i, config in var.instance_configuration :
    aws_instance.ec2_instances[i].id
    if config.associate_elastic_ip
  ][count.index]
  
  # Lấy allocation_id từ resource EIP đã tạo
  allocation_id = aws_eip.instance_eips[count.index].id
}