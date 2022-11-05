output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_subnet_id" {
  value = aws_subnet.public_subnets.*.id
}

output "pri_subnet_id" {
  value = aws_subnet.private_subnets.*.id
}