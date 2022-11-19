resource "aws_db_subnet_group" "scott_dbsubnet" {
  name       = format("sng-%s-rds",
               var.env)
  
  // use 'for' iteration
  subnet_ids = [for subnet in aws_subnet.scott_subnet_rds : subnet.id]

  tags = {
    Name = format("sng-%s-rds",
           var.env)
  }
}

resource "aws_db_instance" "scott_rds" {
  identifier             = format("rds-%s",
                           var.env)

  engine                 = var.db_engine
  allocated_storage      = var.db_storage
  instance_class         = var.db_instance_type
  db_subnet_group_name   = aws_db_subnet_group.scott_dbsubnet.name
  vpc_security_group_ids = [aws_security_group.scott_sg_rds.id]
  skip_final_snapshot    = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
}
