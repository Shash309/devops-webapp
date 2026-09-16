############################################
# Input Variables
############################################

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

variable "key_name" {
  description = <<-EOT
    Name of an EXISTING AWS EC2 key pair to use for SSH access.
    This project does not create a key pair - it must already exist in AWS
    (e.g. the AWS Academy default 'vockey', or one you registered yourself).
  EOT
  type        = string
  default     = "vockey"
}

variable "ssh_allowed_cidr" {
  description = <<-EOT
    CIDR block allowed to SSH (port 22) into the instances.
    Defaults to a placeholder that MUST be overridden - either via
    terraform.tfvars, -var, or TF_VAR_ssh_allowed_cidr, with your current
    public IP in /32 form, e.g. "203.0.113.10/32".
    Determine your IP with: curl -s https://checkip.amazonaws.com
  EOT
  type        = string
}

variable "project_name" {
  description = "Prefix used for resource Name tags"
  type        = string
  default     = "Dev"
}
