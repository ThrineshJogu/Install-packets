resource "aws_route_table" "public_rt" {
  tags = {
    Name = "Terraform_public_RT"
  }
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
}

resource "aws_route_table" "private_rt" {
  tags = {
    Name = "Terraform-private-RT"
  }
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mynat.id
  }
}
