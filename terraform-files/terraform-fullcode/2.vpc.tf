resource "aws_vpc" "myvpc" {
  tags = {
    Name = "Terraform-VPC"
  }
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}
