provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "ubuntu" {
  // Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
  ami                    = "ami-0e9bfdb247cc8de84"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  // Assignment 1. Deploy EC2 Web Server via userdata
  user_data = <<-EOF
              #!/bin/bash
              echo "hello Kyeongbo Kim's Web Server" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "Terraform-Web"
  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    // Assignment 2. Input Web Server Port via Variable
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}