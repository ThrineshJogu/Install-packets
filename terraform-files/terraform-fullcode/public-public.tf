provider "aws" {
  region = "eu-north-1"
}

# ------------------- VPC -------------------
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "Terraform-VPC"
  }
}

# ------------------- Public Subnets -------------------
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-SN-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-SN-2"
  }
}

# ------------------- Internet Gateway -------------------
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Terraform-IGW"
  }
}

# ------------------- Elastic IP for NAT -------------------
resource "aws_eip" "myeip" {
  domain = "vpc"

  tags = {
    Name = "Terraform-EIP"
  }
}

# ------------------- NAT Gateway -------------------
resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "Terraform-NAT"
  }

  depends_on = [aws_internet_gateway.myigw]
}

# ------------------- Route Tables -------------------
## Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "Terraform-public-RT"
  }
}


# ------------------- Route Table Associations -------------------
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ------------------- Security Group -------------------
resource "aws_security_group" "mysg" {
  name        = "Terraform-SG"
  description = "Security Group for Terraform setup"
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

  tags = {
    Name = "Terraform-SG"
  }
}

# ------------------- Launch Template -------------------
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

# ------------------- Load Balancer -------------------
resource "aws_elb" "myelb" {
  name            = "Terraform-LB"
  subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups = [aws_security_group.mysg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags = {
    Name = "Terraform-LB"
  }
}

# ------------------- Auto Scaling Group -------------------
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
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}
