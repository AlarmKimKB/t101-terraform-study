resource "aws_security_group" "rds_sg" {
  vpc_id      = data.terraform_remote_state.dev_vpc.outputs.vpc_id
  name        = "scg-terraform-dev-rds"
  description = "T101 Week3 Study SG"
}

resource "aws_security_group_rule" "rds_sg_inbound" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "rds_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}
