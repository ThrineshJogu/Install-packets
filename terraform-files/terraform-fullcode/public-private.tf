provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "myvpc" {
  tags = {
    Name = "Terraform-VPC"
  }
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "public-SN"
  }
  availability_zone       = "eu-north-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Terraform-IGW"
  }
}

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

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "private-SN"
  }
  availability_zone       = "eu-north-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "terraform-nat-eip"
  }
}

resource "aws_nat_gateway" "mynat" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.public_subnet.id
  connectivity_type = "public"
  tags = {
    Name = "terraform-nat-gateway"
  }
  depends_on = [aws_internet_gateway.myigw]
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

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "mysg" {
  name        = "Terraform-SG"
  description = "This is created by terraform"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "mylt" {
  name          = "Terraform-LT"
  description   = "This is created by terraform"
  image_id      = "ami-07fb0a5bf9ae299a4"
  instance_type = "t3.micro"
  key_name      = "newkey"
  placement {
    availability_zone = "eu-north-1a"
  }
  vpc_security_group_ids = [aws_security_group.mysg.id]
  tags = {
    Name = "MyServer"
  }
}


resource "aws_elb" "myelb" {
  name                   = "Terraform-LB"
  subnets                = [aws_subnet.public_subnet.id] #, aws_subnet.public_subnet2.id]
  security_groups        = [aws_security_group.mysg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags = {
    Name = "Terraform-Lb"
  }
}


resource "aws_autoscaling_group" "myasg" {
  name = "Terraform-ASG"
  launch_template {
    id = aws_launch_template.mylt.id
  }
  min_size             = 1
  max_size             = 6
  desired_capacity     = 2
  health_check_type    = "EC2"
  load_balancers       = [aws_elb.myelb.name]
  vpc_zone_identifier  = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
}



