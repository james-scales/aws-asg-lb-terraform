output "aws_eip" {
  value = aws_eip.nat_eip
}

output "vpc_id" {
  value = aws_vpc.dev.id
}

output "load_balancer_sg" {
  value = aws_security_group.dev_lb_sg.id
}
output "security_group_id" {
  value = aws_security_group.dev_sg.id
}

# Output Subnet IDs that are == public & == private
output "public_subnet_ids" {
  value = [for k, s in aws_subnet.dev_subnet : s.id if var.subnets[k].type == "public"]
}

output "private_subnet_ids" {
  value = [for k, s in aws_subnet.dev_subnet : s.id if var.subnets[k].type == "private"]
}
