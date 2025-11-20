module "network" {
  source        = "./modules/network"
  name_prefix   = "scales-network"
  terraform_tag = "made in Terraform"
  # Define subnets here
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
  source            = "./modules/compute"
  instance_type     = "t3.micro"
  subnet_id         = module.network.public_subnet_ids[0]
  security_group_id = module.network.security_group_id
  vpc_id            = module.network.vpc_id

}

module "load_balancing" {
  source              = "./modules/load_balancing"
  load_balancer_sg    = module.network.load_balancer_sg
  aws_lb_target_group = module.compute.target_group_arn
  aws_launch_template = module.compute.aws_launch_template
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids



}