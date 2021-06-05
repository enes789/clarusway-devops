resource "aws_lb_target_group" "tf-target-group" {
  name     = "tf-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-d962cca4"
}