# Application Load Balancer
variable "alb_name" {
  description = "Load Balancer Name"
  type        = string
}


variable "load_balancer_sg" {
  description = "Load Balancer Security Group"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public Subnet IDs"
}

# Autoscaling Group
variable "asg_name" {
  description = "Autoscaling Group Name"
  type        = string

}

variable "asg_min_size" {
  description = "ASG Min Size"
  type        = number

}

variable "asg_max_size" {
  description = "ASG Max Size"
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

variable "private_subnet_ids" {
  description = "Private Subnet IDs"
}

# Autoscaling Policy
variable "asg_policy_name" {
  description = "ASG Policy Name"
  type        = string

}

variable "asg_policy_instance_warmup" {
  description = "ASG Policy Estimated Instance Warmup"
  type        = number

}

# Misc
variable "aws_lb_target_group" {
  description = "Dev Target Group"
  type        = string

}

variable "aws_launch_template" {
  description = "Dev Launch Template"
  type        = string

}