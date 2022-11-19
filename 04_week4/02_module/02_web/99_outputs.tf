output "alb_dns" {
  value       = aws_lb.scott_alb.dns_name
  description = "The DNS Address of the ALB"
}
