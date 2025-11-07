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
