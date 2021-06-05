resource "aws_lb" "tf-alb" {
  name               = var.ALB_NAME
  internal           = var.INTERNAL
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-asg_sec_group.id]
  subnets            = ["subnet-6c1c8e0a", "subnet-d07d509d"]

  enable_deletion_protection = false

#   tags = {
#     Name = "test"
#   }

  provisioner "local-exec" {
    command = "echo ${var.ALB_NAME}-Endpoint: ${aws_alb.alb.dns_name} >> env_variables"
  }
}