# Instance
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
  description = "Security Group ID"
}

# Target Group
variable "target_group_name" {
  description = "Target Group Name"
  type        = string
}

# Launch Template
variable "launch_template_name" {
  description = "Launch Template Name"
  type        = string
}

variable "lt_image_id" {
  description = "LT AMI ID"
  type        = string
}



variable "vpc_id" {
  description = "Custom Dev VPC"
  type        = string
}






