output "instance_ids" {
  description = "IDs of all instances created"
  value       = aws_instance.ec2_instances[*].id
}

output "key_pair_name" {
  description = "Tên của SSH key pair được sử dụng"
  value       = local.key_pair_name
}

output "key_secret_name" {
  description = "Tên của secret chứa private key (nếu tạo mới)"
  value       = var.create_new_keypair ? aws_secretsmanager_secret.instance_key_secret[0].name : "No secret created - using existing key"
}

output "instance_public_ips" {
  description = "Public IPs of instances (direct from instance or EIP if attached)"
  value = {
    for i, instance in aws_instance.ec2_instances :
    var.instance_configuration[i].name => var.instance_configuration[i].associate_elastic_ip ? (
      length(aws_eip.instance_eips) > 0 ? aws_eip.instance_eips[index(
        [for j, config in var.instance_configuration : j if config.associate_elastic_ip],
        i
      )].public_ip : null
    ) : instance.public_ip
  }
}

output "instance_private_ips" {
  description = "Private IPs of all instances created"
  value = {
    for i, instance in aws_instance.ec2_instances :
    var.instance_configuration[i].name => instance.private_ip
  }
}

output "elastic_ip_ids" {
  description = "IDs of Elastic IPs created"
  value       = aws_eip.instance_eips[*].id
}

output "public_instance_id" {
  description = "ID của instance public"
  value       = aws_instance.ec2_instances[0].id
}

output "private_instance_id" {
  description = "ID của instance private"
  value       = aws_instance.ec2_instances[1].id
}