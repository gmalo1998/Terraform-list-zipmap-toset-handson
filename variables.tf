variable "environment" {
  type = string
}

# CIDR BLOCKS
variable "cidr_blocks" {
  type = list(string)
}

# AVAILABILITY ZONES
variable "availability_zone" {
  type = list(string)
}

# INGRESS PORTS
variable "ingress_ports" {
  type = list(number)
}


# MAP example
variable "instances" {
  type = map(object({
    instance_type=string
    volume_size=number
    volume_type=string
    monitoring= object ({
      enabled=bool
      level=string
    })
}))
}



variable "ec2_key" {
  type    = string
  default = "ec2-putty-key-pair"
}