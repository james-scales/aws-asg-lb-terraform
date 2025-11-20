variable "load_balancer_sg" {
  description = "Load Balancer Security Group"
  type        = string
}

variable "aws_lb_target_group" {
  description = "Dev Target Group"
  type        = string

}

variable "aws_launch_template" {
  description = "Dev Launch Template"
  type        = string

}

variable "public_subnet_ids" {
  description = "Public Subnet IDs"
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs"
}