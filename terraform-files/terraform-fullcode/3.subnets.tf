resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "public-SN"
  }
  availability_zone       = "eu-north-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "private-SN"
  }
  availability_zone       = "eu-north-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}
