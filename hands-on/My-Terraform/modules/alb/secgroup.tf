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
  
  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}