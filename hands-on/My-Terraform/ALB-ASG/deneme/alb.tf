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
  description = "Allow 22, 80"
  ingress {
    description = "Inbound Allowed"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Inbound Allowed"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_lb_target_group" "tf-target-group" {
  name     = "tf-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-d962cca4"
}



resource "aws_lb_listener" "tf-listener" {
  load_balancer_arn = aws_lb.tf-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-target-group.arn
  }
}

resource "aws_lb" "tf-alb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-asg_sec_group.id]
  subnets            = ["subnet-6c1c8e0a", "subnet-d07d509d"]

  enable_deletion_protection = true


  tags = {
    Name = "test"
  }
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.tf-alb.dns_name
}