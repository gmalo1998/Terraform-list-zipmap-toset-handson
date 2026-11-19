resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "multienv-s3-bucket"
  tags = {
    Name = "S3-Bucket-TagName"
  }
}


# EC2 AMI 
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name   = "image-id"
    values = ["ami-0547ecbf0e9b4aeb5"]
  }
}
# EC2 instance vpc
resource "aws_default_vpc" "aws_default_vpc" {}

# EC2 subnets
resource "aws_subnet" "default_subnet" {
  for_each = zipmap(
    var.availability_zones,
    var.cidr_blocks
  )
 
  vpc_id                  = aws_default_vpc.aws_default_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "my-default-subnet"
    Environment = var.environment
  }
}

# EC2 instance security groups
resource "aws_security_group" "ec2_security_groups" {
  description = "This section is for the security groups"
  name        = "${var.environment}-security-group"
  vpc_id      = aws_default_vpc.aws_default_vpc.id

   dynamic "ingress" {
    for_each = var.ingress_ports
      content {
    description = "Inbound traffic on port ${ingress.value}"
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   }
  
  egress {
    description = "Outbound rule for EC2 instance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2 Security Groups"
  }
}

# EC2 Instance

#single map example

resource "aws_instance" "ec2_instance" {
  for_each               = var.instances
  instance_type          = each.value.instance_type
  
  ami                    = data.aws_ami.ubuntu_ami.id
  vpc_security_group_ids = [aws_security_group.ec2_security_groups.id]
  key_name               = var.ec2_key
  subnet_id = aws_subnet.default_subnet["us-east-1a"].id
  monitoring = each.value.monitoring.enabled
  root_block_device {
    volume_size = each.value.volume_size
    volume_type = each.value.volume_type
  }
  tags = {
    Name        = each.key
    Environment = var.environment
    Monitoring_level=each.value.monitoring.level
  }
}


