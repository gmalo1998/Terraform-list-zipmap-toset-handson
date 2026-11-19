environment= "staging"

# example of list collection
ingress_ports = [22,80,443]
availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
cidr_blocks=["172.31.1.0/24","172.31.2.0/24","172.31.3.0/24"]

# nested object
instances = {
staging-instance-1 = {
instance_type="t3.small"
volume_size=10
volume_type="gp3"
monitoring ={
    enabled=true
    level="basic"
}
}
staging-instance-2 = {
instance_type="t3.medium"
volume_size=10
volume_type="gp3"
monitoring ={
    enabled=true
    level="medium"
}
}
}