resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  tags = {
    Name = var.name
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"  # Change to a path that your application will reliably serve with a 200 OK when healthy.
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.this.arn  # Corrected from aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}


# resource "aws_lb_target_group_attachment" "web" {
#   target_group_arn = aws_lb_target_group.web.arn
#   target_id        = var.web_instance_id # Passed from the main configuration
#   port             = 80
# }



resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"  # Example policy, choose based on your compliance needs
  certificate_arn   = var.ssl_certificate_arn      # Reference the imported certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
