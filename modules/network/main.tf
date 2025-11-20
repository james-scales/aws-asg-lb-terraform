resource "aws_vpc" "dev" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    origin = var.terraform_tag
  }
}

############ Subnets ########################
resource "aws_subnet" "dev_subnet" {
  for_each = var.subnets

  vpc_id            = aws_vpc.dev.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  # Check if subnet type is == public
  # Ternary logic: if the condition is true return true, else false
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = {
    # Return map key found in main.tf and add text to tag for each subnet
    # Return subnet type for each subnet
    Name   = "${each.key}"
    Type   = each.value.type
    origin = var.terraform_tag
  }
}

############### NAT ######################
##### Creating locals block to pull public subnets for NAT gateway resource

### Loop through all subnets created by aws_subnet.that, and 
### collect the ids of each subnet only if its type is "public".

locals {
  public_subnet_ids = [
    for subnet_name, subnet_resource in aws_subnet.dev_subnet :
    subnet_resource.id if var.subnets[subnet_name].type == "public"
  ]
}

resource "aws_eip" "nat_eip" {
  # vpc = true

  tags = {
    origin = var.terraform_tag
  }

  depends_on = [aws_internet_gateway.igw]
}

# Subnet_id collects the first public subnet id [0] from the locals resource
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    origin = var.terraform_tag
  }

  depends_on = [aws_internet_gateway.igw]
}

############# IGW ####################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    origin = var.terraform_tag
  }
}

########## Route Table ############
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    origin = var.terraform_tag
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    origin = var.terraform_tag
  }
}

##### Creating locals block to pull public & private subnets for route table resource

### Loop through all subnets created by aws_subnet.that, and 
### collect the ids of each subnet only if its type is "public" & "private".

locals {
  public_subnets = {
    for k, s in var.subnets : k => s
    if s.type == "public"
  }
  private_subnets = {
    for k, s in var.subnets : k => s
    if s.type == "private"
  }
}

# Loops over each private subnet key and creates a route table association
# Toset used to convert a list into a set which is useful for for_each

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.dev_subnet[each.key].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id = aws_subnet.dev_subnet[each.key].id
  
  route_table_id = aws_route_table.public.id
}

###### Security Group ##########
resource "aws_security_group" "dev_sg" {
  name        = "Dev SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev.id

  tags = {
    Name   = "reg_sg"
    origin = var.terraform_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  security_group_id = aws_security_group.dev_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
######## Load Balancer Security Group ##############

resource "aws_security_group" "dev_lb_sg" {
  name        = "Dev LB SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev.id

  tags = {
    Name   = "lb_sg"
    origin = var.terraform_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_lb_http" {
  security_group_id = aws_security_group.dev_lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "egress_lb_rules" {
  security_group_id = aws_security_group.dev_lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}