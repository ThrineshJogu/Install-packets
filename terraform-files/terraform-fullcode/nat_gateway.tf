resource "aws_nat_gateway" "mynat" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.Public_SN.id
  connectivity_type = "public"
  tags = {
    Name = "terraform-nat-gateway"
  }
  depends_on = [aws_internet_gateway.myigw]
}
