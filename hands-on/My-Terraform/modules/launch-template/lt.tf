resource "aws_launch_template" "tf-lt" {
  image_id = var.ec2-ami
  instance_type = var.ec2-type
  key_name = "mykey1"
  vpc_security_group_ids = [aws_security_group.web-server_sec_group.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ec2-name}"
    }
  }
  user_data = filebase64("milliseconds.sh")
}