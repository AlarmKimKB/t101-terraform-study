resource "aws_security_group" "ec2_sg" {
  vpc_id      = data.terraform_remote_state.dev_vpc.outputs.vpc_id
  name        = "scg-terraform-dev-ec2"
  description = "T101 Week3 Study SG"
}

resource "aws_security_group_rule" "ec2_sg_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}
