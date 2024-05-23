output "web_alb_dns_name" {
    description = "the dns name of the web alb"
    value       = aws_lb.web-alb.dns_name
}

output "app_alb_dns_name" {
    description = "the dns name of the app alb"
    value       = aws_lb.app-alb.dns_name
}