resource "aws_security_group" "web-server_sec_group" {
  name        = "ec2-webserver-terraform"
  description = "Allow 22, 80 port from ALB"
  ingress {
    description = "Inbound Allowed"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = var.ALB_SEC_GROUP
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