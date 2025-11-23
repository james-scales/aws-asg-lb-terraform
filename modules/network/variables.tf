# VPC
variable "cidr_block" {
  description = "VPC CIDR Block"
  type        = string

}

variable "enable_dns_hostnames" {
  description = "Enable DNS Hostname"
  type        = bool

}

variable "enable_dns_support" {
  description = "Enable DNS Support"
  type        = bool

}

variable "instance_tenancy" {
  description = "Instance Tenancy"
  type        = string

}

variable "private_route_cidr" {
  description = "Private Route CIDR"
  type        = string
}

variable "public_route_cidr" {
  description = "Public Route CIDR"
  type        = string
}

# Security Groups
variable "sg_name" {
  description = "Web Server Security Group Name"
  type        = string
}

variable "sg_ssh_cidr_ipv4" {
  description = "SSH Ingress IPv4 CIDR"
  type        = string
}

variable "sg_http_cidr_ipv4" {
  description = "HTTP Ingress IPv4 CIDR"
  type        = string
}

variable "egress_cidr_ipv4" {
  description = "Egress IPv4 CIDR"
  type        = string
}

###############

variable "lb_sg_name" {
  description = "LB Security Group Name"
  type        = string
}

variable "lb_sg_http_cidr_ipv4" {
  description = "LB HTTP Ingress IPv4 CIDR"
  type        = string
}

variable "lb_egress_cidr_ipv4" {
  description = "LB Egress IPv4 CIDR"
  type        = string
}

# Misc
variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}
variable "terraform_tag" {
  description = "Tag for Terraform created reources"
  type        = string
}









variable "map_public_ip_on_launch" {
  description = "Map Public IP on Launch "
  type        = bool
  default     = true

}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    type              = string # "public" or "private"
  }))
}
