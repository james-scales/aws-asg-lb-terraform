module "network" {
  source      = "./modules/network"
  name_prefix = "demo-network"
  # Define subnets here
  subnets = {
    public-a = {
      cidr_block        = "10.45.1.0/24"
      availability_zone = "us-east-1a"
      type              = "public"
    }
    public-b = {
      cidr_block        = "10.45.2.0/24"
      availability_zone = "us-east-1b"
      type              = "public"
    }
    private-a = {
      cidr_block        = "10.45.11.0/24"
      availability_zone = "us-east-1a"
      type              = "private"
    }
    private-b = {
      cidr_block        = "10.45.12.0/24"
      availability_zone = "us-east-1b"
      type              = "private"
    }
  }
}

module "compute" {
  source            = "./modules/compute"
  instance_type     = "t3.micro"
  subnet_id         = module.network.private_subnet_ids[0]
  security_group_id = module.network.security_group_id

}