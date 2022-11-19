output "alb_dns" {
    description = "DNS Address of the ALB"
    value       = module.web.alb_dns
}