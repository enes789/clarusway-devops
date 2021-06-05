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

variable "ec2-sec-group" {
  default = [22, 80, 443]
}

variable "ec2-name" {
  default = ["First", "Second"]
}

resource "aws_security_group" "apache_sec_group" {
  name        = "first_project_apache"
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

resource "aws_instance" "apache-ec2" {
  for_each = toset(var.ec2-name)
  ami                    = "ami-0742b4e673072066f"
  instance_type          = "t2.micro"
  key_name               = "mykey1"
  vpc_security_group_ids = [aws_security_group.apache_sec_group.id]
  tags = {
    Name = "Terraform ${each.value} Instance"
  }
  user_data = "${file("create_apache.sh")}"
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ips.txt"
  }
}

output "apache-servers-public-ip" {
  value     = {
    for instance in aws_instance.apache-ec2:
      instance.id => instance.public_ip
  }
  sensitive = true
}
