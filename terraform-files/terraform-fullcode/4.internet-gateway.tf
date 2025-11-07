resource "aws_internet_gateway" "myigw" {
  tags = {
    Name = "Terraform-IGW"
  }
  vpc_id = aws_vpc.myvpc.id
}
