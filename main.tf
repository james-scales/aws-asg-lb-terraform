module "network" {
  source      = "./modules/network"
  name_prefix = var.name_prefix
  # VPC
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy
  terraform_tag        = var.terraform_tag
  # Route Tables
  public_route_cidr  = var.public_route_cidr
  private_route_cidr = var.private_route_cidr
  # Webserver Security Groups
  sg_name           = var.sg_name
  sg_http_cidr_ipv4 = var.sg_http_cidr_ipv4
  sg_ssh_cidr_ipv4  = var.sg_ssh_cidr_ipv4
  egress_cidr_ipv4  = var.egress_cidr_ipv4
  # LB Security Groups
  lb_sg_name           = var.lb_sg_name
  lb_sg_http_cidr_ipv4 = var.lb_sg_http_cidr_ipv4
  lb_egress_cidr_ipv4  = var.lb_egress_cidr_ipv4
  # Define Subnets here
  subnets = {
    public-a = {
      cidr_block        = "10.45.1.0/24"
      availability_zone = "sa-east-1a"
      type              = "public"
    }
    public-b = {
      cidr_block        = "10.45.2.0/24"
      availability_zone = "sa-east-1b"
      type              = "public"
    }

    public-c = {
      cidr_block        = "10.45.3.0/24"
      availability_zone = "sa-east-1c"
      type              = "public"
    }
    private-a = {
      cidr_block        = "10.45.11.0/24"
      availability_zone = "sa-east-1a"
      type              = "private"
    }
    private-b = {
      cidr_block        = "10.45.12.0/24"
      availability_zone = "sa-east-1b"
      type              = "private"
    }
    private-c = {
      cidr_block        = "10.45.13.0/24"
      availability_zone = "sa-east-1c"
      type              = "private"
    }
  }
}

module "compute" {
  source               = "./modules/compute"
  # Instance
  instance_type        = var.instance_type
  subnet_id            = module.network.public_subnet_ids[0]
  security_group_id    = module.network.security_group_id
  # Target Group
  target_group_name    = var.target_group_name
  # Launch Template
  launch_template_name = var.launch_template_name
  lt_image_id          = var.lt_image_id
  vpc_id               = module.network.vpc_id

}

module "load_balancing" {
  source                     = "./modules/load_balancing"
  # Load Balancer
  alb_name                   = var.alb_name
  load_balancer_sg           = module.network.load_balancer_sg
  public_subnet_ids          = module.network.public_subnet_ids
  # Autoscaling Group
  asg_name                   = var.asg_name
  asg_min_size               = var.asg_min_size
  asg_max_size               = var.asg_max_size
  asg_desired_size           = var.asg_desired_size
  asg_hc_grace_period        = var.asg_hc_grace_period
  asg_policy_name            = var.asg_policy_name
  asg_policy_instance_warmup = var.asg_policy_instance_warmup
  private_subnet_ids         = module.network.private_subnet_ids
  # Misc
  aws_lb_target_group        = module.compute.target_group_arn
  aws_launch_template        = module.compute.aws_launch_template
  
  
}