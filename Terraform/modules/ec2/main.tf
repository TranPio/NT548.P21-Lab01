locals {
  project_name = var.project_name
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
  key_name               = var.instance_configuration[count.index].key_name
  
  # Tạo public IP cho instance nếu được chỉ định
  associate_public_ip_address = !var.instance_configuration[count.index].associate_elastic_ip

  # User data script nếu có
  user_data = var.instance_configuration[count.index].user_data_file != null ? file(var.instance_configuration[count.index].user_data_file) : null

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