# Terraform_Map-Object-NestedObject_Handson
# Terraform-list-zipmap-toset-handson
## Terraform Variables & Input Validation

### Concepts Covered
- Input Variables and Data Types
- Primitive Types (`string`, `number`, `bool`)
- Collection Types (`list`, `map`)
- Complex Types (`map(object)`)
- Variable Validation Blocks
- For Expressions
- AWS Data Sources

### Variables Implemented
- `environment` – Environment selection (dev, prod, staging)
- `cidr_blocks` – Subnet CIDR configurations
- `availability_zones` – AWS Availability Zones
- `ingress_ports` – Security Group ingress ports
- `instances` – Multiple EC2 configurations using Map of Objects
- `ec2_key` – EC2 Key Pair name

### Validation Rules
- Restrict environment to allowed values.
- Validate CIDR block syntax.
- Ensure Availability Zones are available in the configured AWS region.
- Validate ingress ports (1–65535).
- Ensure at least one EC2 instance is defined.
- Validate EBS volume size (greater than 5 GB and less than 100 GB).

### Terraform Functions Used
`length()`, `contains()`, `alltrue()`, `anytrue()`, `can()`, `cidrhost()`, `trimspace()`, `values()`.

### Testing Commands
```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

**Objective:** Prevent invalid infrastructure configurations through Terraform input validation before AWS resource provisioning.


> Your code has corrupted and you need to revert or rollback your changes