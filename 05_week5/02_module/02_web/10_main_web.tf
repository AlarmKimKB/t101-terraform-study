
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = var.s3_vpc_location
    key    = var.s3_vpc_key
    region = var.s3_vpc_region
  }
}

resource "aws_subnet" "scott_subnet_web" {
  // use 'count' iteration
  count             = length(var.subnet_web_cidr)
  vpc_id            = data.terraform_remote_state.db.outputs.vpcid
  cidr_block        = var.subnet_web_cidr[count.index]
  availability_zone = var.subnet_web_az[count.index]

  tags = {
    Name = format("sub-%s-web-%s",
           var.env,
           // ap-northeast-2a > a
           substr(split("-", var.subnet_web_az[count.index])[2], 1, 1)
           )
  }
}

resource "aws_internet_gateway" "scott_igw" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = format("igw-%s",
           var.env)
  }
}

resource "aws_route_table" "scott_rt_web" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = format("rtb-%s-web",
           var.env)
  }
}

resource "aws_route_table_association" "scott_web_rt_association" {
  // use 'count' iteration
  count          = length(aws_subnet.scott_subnet_web)
  subnet_id      = aws_subnet.scott_subnet_web[count.index].id
  route_table_id = aws_route_table.scott_rt_web.id
}


resource "aws_route" "scott_default_route" {
  route_table_id         = aws_route_table.scott_rt_web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.scott_igw.id
}

resource "aws_security_group" "scott_sg_web" {
  vpc_id      = data.terraform_remote_state.db.outputs.vpcid
  name        = format("scg-%s-web",
                var.env)
  description = "Web Security Group"
}

resource "aws_security_group_rule" "web_sg_inbound" {
  // use 'Local Variables'
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
  security_group_id = aws_security_group.scott_sg_web.id
}

resource "aws_security_group_rule" "web_sg_outbound" {
  // use 'Local Variables'
  type              = "egress"
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.all_protocol
  cidr_blocks       = local.all_ips
  security_group_id = aws_security_group.scott_sg_web.id
}

# data "template_file" "user_data" {
#   template = file("user-data.sh")

#   vars = {
#     server_port = 8080
#     db_address  = data.terraform_remote_state.db.outputs.address
#     db_port     = data.terraform_remote_state.db.outputs.port
#   }
# }

data "aws_ami" "scott_amazonlinux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "scott_launch_config" {
  name            = format("lac-%s-web",
                    var.env)

  image_id        = data.aws_ami.scott_amazonlinux2.id
  instance_type   = var.ec2_type
  security_groups = [aws_security_group.scott_sg_web.id]

  associate_public_ip_address = true

  // 'path.root' > use Root Module's File.
  user_data = templatefile("${path.root}/11_user-data.sh", {
    server_port = local.http_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "scott_asg" {
  name                 = format("asg-%s-web",
                         var.env)

  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.scott_alb_tg.arn]
  launch_configuration = aws_launch_configuration.scott_launch_config.name
  
  // use 'for' iteration
  vpc_zone_identifier  = [for subnet in aws_subnet.scott_subnet_web : subnet.id]
  min_size             = var.asg_min_ec2
  max_size             = var.asg_max_ec2

  tag {
    key                 = "Name"
    value               = format("asg-%s-web",
                          var.env)
    propagate_at_launch = true
  }
}

resource "aws_lb" "scott_alb" {
  name               = format("alb-%s-web",
                       var.env)

  load_balancer_type = "application"

  // use 'for' iteration
  subnets            = [for subnet in aws_subnet.scott_subnet_web : subnet.id]
  security_groups    = [aws_security_group.scott_sg_web.id]

  tags = {
    Name = format("alb-%s-web",
           var.env)
  }
}

resource "aws_lb_listener" "scott_http" {
  load_balancer_arn = aws_lb.scott_alb.arn
  port              = local.http_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - Terraform Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "scott_alb_tg" {
  name     = format("tg-alb-%s-web",
             var.env)

  port     = local.http_port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.db.outputs.vpcid

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

resource "aws_lb_listener_rule" "scott_albrule" {
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

