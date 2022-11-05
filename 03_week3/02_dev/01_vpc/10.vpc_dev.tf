resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("vpc-%s-%s", 
                  var.study_name, 
                  var.env)
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id               = aws_vpc.vpc.id

  tags = {
    Name = format("igw-%s-%s", 
                  var.study_name, 
                  var.env)
  }
}



resource "aws_subnet" "public_subnets" {
  count                   = length(var.pub_sub_cidr)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_cidr[count.index].cidr
  availability_zone       = var.pub_sub_cidr[count.index].az

  map_public_ip_on_launch = true

  tags = {
    // ex. sub-test-prd-pub-a
    Name = format("sub-%s-%s-pub-%s", 
                  var.study_name, 
                  var.env, 
                  substr(split("-", var.pub_sub_cidr[count.index].az)[2], 1, 1))
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.pri_sub_cidr)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pri_sub_cidr[count.index].cidr
  availability_zone       = var.pri_sub_cidr[count.index].az


  tags = {
    // ex. sub-test-prd-pri-a
    Name = format("sub-%s-%s-pri-%s",
                  var.study_name, 
                  var.env, 
                  substr(split("-", var.pri_sub_cidr[count.index].az)[2], 1, 1))
  }
}

resource "aws_eip" "eip_nat" {
  depends_on = [aws_internet_gateway.igw]
  count      = 1

  vpc        = true

  tags = {
    Name = format("eip-%s-%s-nat", 
                  var.study_name, 
                  var.env)
  }
}


resource "aws_nat_gateway" "nat" {
  depends_on    = [aws_internet_gateway.igw]
  count         = 1

  allocation_id = aws_eip.eip_nat[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = format("nat-%s-%s", 
                  var.study_name, 
                  var.env)
  }
}


resource "aws_route_table" "public_rtb" {
  vpc_id       = aws_vpc.vpc.id

  // "0.0.0.0/0" 에 대해 IGW 로 라우팅
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("rtb-%s-%s-pub", 
                  var.study_name, 
                  var.env)
  }
}

  // association public subnet with route table

resource "aws_route_table_association" "public_subnets_association" {
  count          = (length(aws_route_table.public_rtb) > 0) ? length(var.pub_sub_cidr) : 0

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}




resource "aws_route_table" "private_rtb" {
  vpc_id       = aws_vpc.vpc.id
  count        = 1

  dynamic "route" {
    for_each = var.pri_sub_cidr[count.index].use_nat ? [true] : []

    content {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
    }
  }
  tags = {
    Name = format("rtb-%s-%s-pri", 
                  var.study_name, 
                  var.env)
  }
}

  // association private subnet with route table

resource "aws_route_table_association" "private_subnets_association" {
  count          = (length(aws_route_table.private_rtb) > 0) ? length(var.pri_sub_cidr) : 0

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rtb[0].id
}


