terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.42.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

resource "aws_security_group" "alb-asg_sec_group" {
  name        = "alb-asg-terraform"
  description = "Allow 22, 443, 80"
  dynamic "ingress" {
    for_each = var.ec2-sec-group
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_launch_template" "tf-lt" {
  image_id = var.ec2-ami
  instance_type = var.ec2-type
  key_name = "mykey1"
  vpc_security_group_ids = [aws_security_group.alb-asg_sec_group.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ec2-name}"
    }
  }
  user_data = filebase64("milliseconds.sh")
}

resource "aws_autoscaling_group" "tf-asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.tf-lt.id
    version = "$Latest"
  }
}

