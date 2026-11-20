variable "environment" {
  type = string
  validation {
    condition = contains(
      ["dev","prod","staging"],lower(trimspace(var.environment))
    )
    error_message = "environment should be prod,dev and staging"
  }
}

# CIDR BLOCKS
variable "cidr_blocks" {
  type = list(string)
  validation {
    condition = length(var.cidr_blocks) > 0
    error_message = "At least one CIDR block must be provided."
  }
  validation {
    condition = alltrue([
    for cidr in var.cidr_blocks :
    can(cidrhost(cidr,0))
    ])
    error_message = "All values must be valid CIDR blocks."
  }
  validation {
  condition = length(var.cidr_blocks) == length(distinct(var.cidr_blocks))
  error_message = "Duplicate CIDR blocks are not allowed."
}
}

# AVAILABILITY ZONES
variable "availability_zones" {
  type = list(string)
  validation {
    condition = length(var.availability_zones) > 0
    error_message = "At least one Availability Zone must be provided."
  }
  validation {
    condition = alltrue([
      for az in var.availability_zones :
      length(trimspace(az)) > 0
    ])
    error_message = "Availability Zone names cannot be empty."
  }
   validation {
    condition = alltrue([
      for az in var.availability_zones :
      contains(data.aws_availability_zones.available.names, az)
    ])
    error_message = "Please provide valid and available AWS Availability Zones."
  }
  validation {
  condition = length(var.availability_zones) == length(distinct(var.availability_zones))
  error_message = "Duplicate Availability Zones are not allowed."
}
}

# INGRESS PORTS
variable "ingress_ports" {
  type = list(number)
  validation {
    condition = length(var.ingress_ports) > 0
    error_message = "At least one ingress port must be provided."
  }

  validation {
    condition = alltrue([
      for port in var.ingress_ports :
      port >= 1 && port <= 65535
    ])
    error_message = "Ingress ports must be between 1 and 65535."
  }
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

validation {
  condition = length(var.instances) > 0
error_message= "Instance should be more than 0"
}
validation {
  condition = alltrue([
      for instance in values(var.instances) :
      instance.volume_size > 5 && instance.volume_size < 100
    ])

    error_message = "Volume size must be greater than 5 and less than 100."
  }
  validation {
  condition = alltrue([
    for instance in values(var.instances) :
    contains(["gp2", "gp3"], instance.volume_type)
  ])

  error_message = "Volume type must be gp2 or gp3."
}

  validation {
  condition = alltrue([
    for instance in values(var.instances) :
    contains(["basic", "detailed"], instance.monitoring.level)
  ])

  error_message = "Monitoring level must be basic or detailed."
}
}

variable "ec2_key" {
  type    = string
  default = "ec2-putty-key-pair"
}