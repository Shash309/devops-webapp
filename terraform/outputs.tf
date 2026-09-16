############################################
# Outputs
############################################

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.dev_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.dev_sg.id
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.dev_server[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances (for Ansible inventory)"
  value       = aws_instance.dev_server[*].public_ip
}

output "instance_public_dns" {
  description = "Public DNS names of the EC2 instances"
  value       = aws_instance.dev_server[*].public_dns
}

output "ami_id_used" {
  description = "The Amazon Linux 2023 AMI ID resolved dynamically via SSM"
  value       = data.aws_ssm_parameter.al2023_ami.value
  sensitive   = true
}
