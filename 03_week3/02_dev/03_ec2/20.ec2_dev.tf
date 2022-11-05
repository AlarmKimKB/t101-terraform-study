
data "aws_ami" "recent_amazonlinux2" {
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

resource "aws_launch_template" "dev_asg_template" {
  description   = "test-template-t101-study"
  name          = "dev-terraform-template"

  // instance option
  image_id      = data.aws_ami.recent_amazonlinux2.id
  instance_type = "t2.micro"
  # key_name = "test"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(
    templatefile(
      "21.user-data.sh", {
      server_port = 80
      db_address  = data.terraform_remote_state.dev_rds.outputs.dev_rds_address
      db_port     = data.terraform_remote_state.dev_rds.outputs.dev_rds_port
  }))

  # iam_instance_profile {
  #   name = "test"
  # }

  // ebs option
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"

      // ebs encryption
      encrypted = false
      # kms_key_id = ""

      delete_on_termination = true
    }
  }
  
  // tags option
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ec2-terraform-asg"
    }
  }
}

# resource "aws_launch_configuration" "scott_launch_config" {
#   name_prefix     = "t101-launch-config-"
#   image_id        = data.aws_ami.scott_amazonlinux2.id
#   instance_type   = "t2.micro"
#   security_groups = [aws_security_group.scott_sg.id]
#   associate_public_ip_address = true

#   # Render the User Data script as a template
#   user_data = templatefile("user-data.sh", {
#     server_port = 8080
#     db_address  = data.terraform_remote_state.db.outputs.address
#     db_port     = data.terraform_remote_state.db.outputs.port
#   })

#   # Required when using a launch configuration with an auto scaling group.
#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_autoscaling_group" "dev_asg" {
  name                 = "dev-terraform-asg"
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.dev_alb_tg.arn]
  vpc_zone_identifier  = [
    data.terraform_remote_state.dev_vpc.outputs.pri_subnet_id[0],
    data.terraform_remote_state.dev_vpc.outputs.pri_subnet_id[1]
  ]
  min_size = 2
  max_size = 10

  launch_template {
    id      = aws_launch_template.dev_asg_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "dev-terraform-by-asg"
    propagate_at_launch = true
  }
}

