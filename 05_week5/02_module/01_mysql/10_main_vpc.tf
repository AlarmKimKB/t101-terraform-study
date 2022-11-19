
resource "aws_vpc" "scott_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = format("vpc-%s",
           var.env)
    }
}

resource "aws_subnet" "scott_subnet_rds" {
  // use 'count' iteration
  count             = length(var.subnet_rds_cidr)

  vpc_id            = aws_vpc.scott_vpc.id
  cidr_block        = var.subnet_rds_cidr[count.index]
  availability_zone = var.subnet_rds_az[count.index]

  tags = {
    // sub-stg-rds-a
    Name = format("sub-%s-rds-%s",
           var.env,
           // ap-northeast-2a > a
           substr(split("-", var.subnet_rds_az[count.index])[2], 1, 1)
           )}
}

resource "aws_route_table" "scott_rt_rds" {
  vpc_id = aws_vpc.scott_vpc.id

  tags = {
    Name = format("rtb-%s-rds",
           var.env)
  }
}

resource "aws_route_table_association" "scott_rds_rt_association" {
  // use 'count' iteration
  count          = length(aws_subnet.scott_subnet_rds)

  subnet_id      = aws_subnet.scott_subnet_rds[count.index].id
  route_table_id = aws_route_table.scott_rt_rds.id
}

resource "aws_security_group" "scott_sg_rds" {
  vpc_id      = aws_vpc.scott_vpc.id
  name        = format("scg-%s-rds",
                var.env)
  description = "RDS Security Group"
}

resource "aws_security_group_rule" "rds_sg_inbound" {
  // use 'local variables'
  type              = "ingress"
  from_port         = local.rds_port
  to_port           = local.rds_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
  security_group_id = aws_security_group.scott_sg_rds.id
}

resource "aws_security_group_rule" "rds_sg_outbound" {
  // use 'local variables'
  type              = "egress"
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.all_protocol
  cidr_blocks       = local.all_ips
  security_group_id = aws_security_group.scott_sg_rds.id
}