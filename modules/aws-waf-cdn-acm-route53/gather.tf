data "aws_route53_zone" "zone" {
  name         = var.domain-name
  private_zone = false
}

# data "aws_lb" "web-elb" {
#   name = var.web-alb-name
# }

# data "aws_lb" "app-elb" {
#   name = var.app-alb-name
# }

data "aws_acm_certificate" "cert" {
  domain         = var.domain-name
  statuses = ["ISSUED"]
}