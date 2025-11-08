resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "Public-SN"
  }
  availability_zone       = "eu-north-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "Private-SN"
  }
  availability_zone       = "eu-north-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}
