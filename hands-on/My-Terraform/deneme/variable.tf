variable "ec2-name" {
  default = "Docker-instance"
}

variable "ec2-type" {
  default = "t2.micro"
  sensitive = true
}

variable "ec2-ami" {
  default = "ami-0742b4e673072066f"
}

variable "ec2-sec-group" {
  default = [22, 80, 443]
}