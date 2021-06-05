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
}

resource "aws_security_group" "terraform_sec_group" {
  name        = "terraform-deneme"
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

resource "aws_instance" "tf-ec2" {
  ami                    = var.ec2-ami
  instance_type          = var.ec2-type
  key_name               = "mykey1"
  vpc_security_group_ids = [aws_security_group.terraform_sec_group.id]
  iam_instance_profile   = "terraform"
  tags = {
    Name = "${var.ec2-name}"
  }

  user_data = <<-EOF
              #! /bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              # install docker-compose
              curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
              -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOF
}

output "myec2-public-ip" {
  value     = aws_instance.tf-ec2.public_ip
  sensitive = true
}
