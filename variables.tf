variable "region" {
  description = "Default AWS region"
  type        = string
  default     = "sa-east-1"
}

variable "name_prefix" {
  description = "VPC Name Prefix"
  type        = string

}
variable "terraform_tag" {
  description = "Terraform Tags"
  type        = string
}

# Network
# VPC
variable "cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS Hostnames "
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS Support "
  type        = string
}

variable "instance_tenancy" {
  description = "Instance Tenancy "
  type        = string
}

# Route Table
variable "public_route_cidr" {
  description = "Public Route CIDR"
  type        = string
}
variable "private_route_cidr" {
  description = "Private Route CIDR"
  type        = string
}

# Web Server Security Groups
variable "sg_name" {
  description = "Web Server Security Group Name"
  type        = string
}

variable "sg_http_cidr_ipv4" {
  description = "SSH Ingress IPv4 CIDR"
  type        = string
}
variable "sg_ssh_cidr_ipv4" {
  description = "HTTP Ingress IPv4 CIDR"
  type        = string
}
variable "egress_cidr_ipv4" {
  description = "Egress IPv4 CIDR"
  type        = string
}

# LB Security Groups
variable "lb_sg_name" {
  description = "LB Security Group Name"
  type        = string
}

variable "lb_sg_http_cidr_ipv4" {
  description = "LB HTTP Ingress IPv4 CIDR"
  type        = string
}

variable "lb_egress_cidr_ipv4" {
  description = "LB Egress IPv4 CIDR"
  type        = string
}

# Compute
variable "target_group_name" {
  description = "Prefix for naming resources"
  type        = string
}

variable "launch_template_name" {
  description = "Launch Template Name"
  type        = string
}

variable "lt_image_id" {
  description = "LT AMI ID"
  type        = string

}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

# Load Balancer & ASG
variable "alb_name" {
  description = "Load Balancer Name"
  type        = string
}
variable "asg_name" {
  description = "Autoscaling Group Name"
  type        = string
}
variable "asg_min_size" {
  description = "ASG Min Size"
  type        = number
}
variable "asg_max_size" {
  description = "ASG Max Siz"
  type        = number
}
variable "asg_desired_size" {
  description = "ASG Desired Capacity"
  type        = number
}
variable "asg_hc_grace_period" {
  description = "ASG HC Grace Period"
  type        = number
}
variable "asg_policy_name" {
  description = "ASG Policy Name"
  type        = string
}
variable "asg_policy_instance_warmup" {
  description = "ASG Policy Estimated Instance Warmup"
  type        = number
}



