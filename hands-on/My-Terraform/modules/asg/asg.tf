resource "aws_autoscaling_group" "tf-asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = var.LAUNCH_TEMPLATE_ID
    version = "$Latest"
  }
}