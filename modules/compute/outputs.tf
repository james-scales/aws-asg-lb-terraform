output "aws_lb_target_group" {
  value = aws_lb_target_group.dev_tg
}

output "aws_launch_template" {
  value = aws_launch_template.dev_lt.id
}

output "target_group_arn" {
  description = "ARN of the dev target group"
  value       = aws_lb_target_group.dev_tg.arn
}