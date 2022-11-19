
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = var.s3_vpc_location
    key    = var.s3_vpc_key
    region = var.s3_vpc_region
  }
}

resource "aws_subnet" "scott_subnet1" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = var.subnet1_cidr

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "${var.env}-terraform-subnet1"
  }
}

resource "aws_subnet" "scott_subnet2" {
  vpc_id     = data.terraform_remote_state.db.outputs.vpcid
  cidr_block = var.subnet2_cidr

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "${var.env}-terraform-subnet2"
  }
}

resource "aws_internet_gateway" "scott_igw" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "${var.env}-terraform-igw"
  }
}

resource "aws_route_table" "scott_rt" {
  vpc_id = data.terraform_remote_state.db.outputs.vpcid

  tags = {
    Name = "${var.env}-terraform-rt"
  }
}

resource "aws_route_table_association" "scott_rt_association1" {
  subnet_id      = aws_subnet.scott_subnet1.id
  route_table_id = aws_route_table.scott_rt.id
}

resource "aws_route_table_association" "scott_rt_association2" {
  subnet_id      = aws_subnet.scott_subnet2.id
  route_table_id = aws_route_table.scott_rt.id
}

resource "aws_route" "scott_default_route" {
  route_table_id         = aws_route_table.scott_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.scott_igw.id
}

resource "aws_security_group" "scott_sg" {
  vpc_id      = data.terraform_remote_state.db.outputs.vpcid
  name        = "${var.env}-sg-web"
  description = "Terraform Study SG - Web"
}

resource "aws_security_group_rule" "scott_sg_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.scott_sg.id
}

resource "aws_security_group_rule" "scott_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.scott_sg.id
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
  name     = "${var.env}-terraform-launch-config"
  image_id        = data.aws_ami.scott_amazonlinux2.id
  instance_type   = var.ec2_type
  security_groups = [aws_security_group.scott_sg.id]
  associate_public_ip_address = true

  # Render the User Data script as a template
  user_data = templatefile("${path.root}/11_user-data.sh", {
    server_port = 80
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  })

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "scott_asg" {
  name                 = "${var.env}-terraform-asg"
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.scott_albtg.arn]
  launch_configuration = aws_launch_configuration.scott_launch_config.name
  vpc_zone_identifier  = [aws_subnet.scott_subnet1.id, aws_subnet.scott_subnet2.id]
  min_size             = var.asg_min_ec2
  max_size             = var.asg_max_ec2

  tag {
    key                 = "Name"
    value               = "${var.env}-terraform-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "scott_alb" {
  name               = "${var.env}-terraform-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.scott_subnet1.id, aws_subnet.scott_subnet2.id]
  security_groups    = [aws_security_group.scott_sg.id]

  tags = {
    Name = "${var.env}-terraform-alb"
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
      message_body = "404: page not found - Terraform Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "scott_albtg" {
  name = "t101-alb-tg"
  port     = 80
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
    target_group_arn = aws_lb_target_group.scott_albtg.arn
  }
}

