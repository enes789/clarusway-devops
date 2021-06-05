resource "aws_lb_listener" "tf-listener" {
  load_balancer_arn = aws_lb.tf-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.TARGET_GROUP_ARN
  }
}