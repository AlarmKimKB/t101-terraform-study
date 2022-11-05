resource "aws_db_subnet_group" "dev_rds_sng" {
  name       = "dev-t101-subnet-group"
  subnet_ids = [
    data.terraform_remote_state.dev_vpc.outputs.pri_subnet_id[0],
    data.terraform_remote_state.dev_vpc.outputs.pri_subnet_id[1]]

  tags = {
    Name = "dev-terraform-sng"
  }
}

resource "aws_db_instance" "dev_rds" {
  identifier_prefix      = "dev-rds-t101"
  allocated_storage      = 10
  
  // DB engine
  engine                 = "mysql"
  engine_version         = "8.0.28"
  instance_class         = "db.t2.micro"

  // DB Info
  db_name                = var.db_name
  port                   = 3389
  username               = var.db_username
  password               = var.db_password

#   parameter_group_name   = ""
  db_subnet_group_name   = aws_db_subnet_group.dev_rds_sng.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

#   multi_az               = false
#   deletion_protection    = true
  skip_final_snapshot    = true
  
  tags = {
    Name = "rds-terraform-t101"
  }
}
