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
  subnets                = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  vpc_security_group_ids = [aws_security_group.mysg.id]
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
  vpc_zone_identifier  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

