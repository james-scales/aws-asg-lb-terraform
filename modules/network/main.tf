resource "aws_vpc" "test" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "test"
  }
}

############ Subnets ########################
resource "aws_subnet" "that" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.test.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  # Check if subnet type is == public
  # Ternary logic: if the condition is true return true, else false
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = {
    # Return map key found in main.tf and add text to tag for each subnet
    # Return subnet type for each subnet
    Name = "${each.key}"
    Type = each.value.type
  }
}

############### NAT ######################
##### Creating locals block to pull public subnets for NAT gateway resource

### Loop through all subnets created by aws_subnet.that, and 
### collect the ids of each subnet only if its type is "public".

locals {
  public_subnet_ids = [
    for subnet_name, subnet_resource in aws_subnet.that :
    subnet_resource.id if var.subnets[subnet_name].type == "public"
  ]
}

resource "aws_eip" "nat_eip" {
  # vpc = true

  tags = {
    Name = "nat"
  }
}

# Subnet_id collects the first public subnet id [0] from the locals resource
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

############# IGW ####################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test.id

  # tags = {
  #   Name    = "app1_IG"
  # }
}

########## Route Table ############
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

##### Creating locals block to pull public & private subnets for route table resource

### Loop through all subnets created by aws_subnet.that, and 
### collect the ids of each subnet only if its type is "public" & "private".

locals {
  public_subnet_keys  = [for k, s in var.subnets : k if s.type == "public"]
  private_subnet_keys = [for k, s in var.subnets : k if s.type == "private"]
}

# Loops over each private subnet key and creates a route table association
# Toset used to convert a list into a set which is useful for for_each

resource "aws_route_table_association" "private" {
  for_each = toset(local.private_subnet_keys)

  subnet_id      = aws_subnet.that[each.key].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  for_each = toset(local.public_subnet_keys)

  subnet_id      = aws_subnet.that[each.key].id
  route_table_id = aws_route_table.public.id
}

###### Security Group ##########
resource "aws_security_group" "scales_sg" {
  name        = "Scales SG"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.test.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.scales_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.scales_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  security_group_id = aws_security_group.scales_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
