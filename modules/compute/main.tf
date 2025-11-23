data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion_host" {
  ami             = data.aws_ami.linux.id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]


  tags = {
    Name = "host"
  }
}

#### Target Group ####
resource "aws_lb_target_group" "dev_tg" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 60
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    matcher             = "200"
  }

  tags = {
    Name = "devTargetGroup"
  }
}

#### Launch Template ####
# resource "tls_private_key" "MyLinuxBox" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# data "tls_public_key" "MyLinuxBox" {
#   private_key_pem = tls_private_key.MyLinuxBox.private_key_pem
# }

# output "private_key" {
#   value     = tls_private_key.MyLinuxBox.private_key_pem
#   sensitive = true
# }

# output "public_key" {
#   value = data.tls_public_key.MyLinuxBox.public_key_openssh
# }
resource "aws_launch_template" "dev_lt" {
  name_prefix   = var.launch_template_name
  image_id      = var.lt_image_id
  instance_type = var.instance_type

  # key_name = "MyLinuxBox"

  vpc_security_group_ids = [var.security_group_id]

  user_data = filebase64("${path.root}/userdata.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "dev_lt"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}



