provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_vpc" "scott_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "t101-scott-vpc"
  }
}

resource "aws_subnet" "scott_subnet_1" {
  vpc_id     = aws_vpc.scott_vpc.id
  cidr_block = "10.200.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "t101-scott-subnet1"
  }
}

resource "aws_subnet" "scott_subnet_2" {
  vpc_id     = aws_vpc.scott_vpc.id
  cidr_block = "10.200.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "t101-scott-subnet2"
  }
}


resource "aws_internet_gateway" "scott_igw" {
  vpc_id = aws_vpc.scott_vpc.id

  tags = {
    Name = "t101-scott-igw"
  }
}

resource "aws_route_table" "scott_rtb" {
  vpc_id = aws_vpc.scott_vpc.id

  tags = {
    Name = "t101-scott-rtb"
  }
}

resource "aws_route_table_association" "scott_rtassociation1" {
  subnet_id      = aws_subnet.scott_subnet_1.id
  route_table_id = aws_route_table.scott_rtb.id
}

resource "aws_route_table_association" "scott_rtassociation2" {
  subnet_id      = aws_subnet.scott_subnet_2.id
  route_table_id = aws_route_table.scott_rtb.id
}

resource "aws_route" "scotT_defaultroute" {
  route_table_id         = aws_route_table.scott_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.scott_igw.id
}
