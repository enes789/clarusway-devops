resource "aws_security_group" "server-sg" {
  name   = "WebServerSecurityGroup"
  vpc_id = "vpc-d962cca4"
  tags = {
    "Name" = "tf-WebServerSecurityGroup"
  }
  ingress {
    from_port       = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
    to_port         = 80
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 22
  }
  egress {
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 0
  }
}

resource "aws_security_group" "alb-sg" {
  name   = "ALBSecurityGroup"
  vpc_id = "vpc-d962cca4"
  tags = {
    "Name" = "tf-ALBSecurityGroup"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 80
  }
  egress {
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 0
  }
}

resource "aws_security_group" "db-sg" {
  name   = "RDSSecurityGroup"
  vpc_id = "vpc-d962cca4"
  tags = {
    "Name" = "tf-RDSSecurityGroup"
  }
  ingress {
    from_port       = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.server-sg.id]
    to_port         = 3306
  }
  egress {
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    to_port     = 0
  }
}