resource "aws_lb" "scott_alb" {
  name               = "t101-scott-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.scott_subnet_1.id, aws_subnet.scott_subnet_2.id]
  security_groups = [aws_security_group.scott_sg.id]

  tags = {
    Name = "t101-scott-alb"
  }
}

resource "aws_lb_listener" "scott_http" {
  load_balancer_arn = aws_lb.scott_alb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "scott_alb_tg" {
  name = "t101-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.scott_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "scott_alb_rule" {
  listener_arn = aws_lb_listener.scott_http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scott_alb_tg.arn
  }
}

output "scott_alb_dns" {
  value       = aws_lb.scott_alb.dns_name
  description = "The DNS Address of the ALB"
}
