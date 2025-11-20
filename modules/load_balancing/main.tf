# Load Balancer Resources
resource "aws_lb" "dev_alb" {
  name                       = "dev-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.load_balancer_sg]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false
  #Lots of death and suffering here, make sure it's false

  tags = {
    Name = "devLoadBalancer"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.dev_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.aws_lb_target_group
  }
}


# Auto Scaling Group
resource "aws_autoscaling_group" "dev_asg" {
  name_prefix               = "dev-auto-scaling-group-"
  min_size                  = 3
  max_size                  = 9
  desired_capacity          = 6
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300
  force_delete              = true

  target_group_arns = [var.aws_lb_target_group]

  launch_template {
    id      = var.aws_launch_template
    version = "$Latest"
  }

  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]

  # Instance protection for launching
  initial_lifecycle_hook {
    name                  = "instance-protection-launch"
    lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
    default_result        = "CONTINUE"
    heartbeat_timeout     = 60
    notification_metadata = "{\"key\":\"value\"}"
  }

  # Instance protection for terminating
  initial_lifecycle_hook {
    name                 = "scale-in-protection"
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 300
  }

  tag {
    key                 = "Name"
    value               = "dev-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }
}


# Auto Scaling Policy
resource "aws_autoscaling_policy" "dev_scaling_policy" {
  name                   = "dev-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.dev_asg.name

  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

# Enabling instance scale-in protection
resource "aws_autoscaling_attachment" "dev_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.dev_asg.name
  lb_target_group_arn    = var.aws_lb_target_group
}
