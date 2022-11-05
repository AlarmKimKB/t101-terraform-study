
resource "aws_lb" "dev_alb" {
  name               = "dev-alb-terraform-t101"
  load_balancer_type = "application"
  subnets            = [
    data.terraform_remote_state.dev_vpc.outputs.pub_subnet_id[0],
    data.terraform_remote_state.dev_vpc.outputs.pub_subnet_id[1]]
  security_groups    = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "dev-alb-terraform-t101"
  }
}

resource "aws_lb_listener" "dev_http" {
  load_balancer_arn = aws_lb.dev_alb.arn
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

resource "aws_lb_target_group" "dev_alb_tg" {
  name = "dev-terraform-alb-tg-t101"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.dev_vpc.outputs.vpc_id

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

resource "aws_lb_listener_rule" "dev_alb_rule" {
  listener_arn = aws_lb_listener.dev_http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_alb_tg.arn
  }
}

output "dev_alb_dns" {
  value       = aws_lb.dev_alb.dns_name
  description = "The DNS Address of the ALB"
}
