variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.45.0.0/16"

}

variable "instance_tenancy" {
  description = "Instance Tenancy"
  type        = string
  default     = "default"

}

variable "enable_dns_hostnames" {
  description = "Enable DNS Hostname"
  type        = bool
  default     = true

}

variable "enable_dns_support" {
  description = "Enable DNS Support"
  type        = bool
  default     = true

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
