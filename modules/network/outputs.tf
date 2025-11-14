output "aws_eip" {
  value = aws_eip.nat_eip
}

# Output Subnet IDs that are == public & == private
output "public_subnet_ids" {
  value = [for k, s in aws_subnet.that : s.id if var.subnets[k].type == "public"]
}

output "private_subnet_ids" {
  value = [for k, s in aws_subnet.that : s.id if var.subnets[k].type == "private"]
}

output "security_group_id" {
  value = aws_security_group.scales_sg.id
}
