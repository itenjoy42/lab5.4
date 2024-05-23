data "aws_subnet" "public-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.public-subnet1]
  }
}

data "aws_subnet" "public-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.public-subnet2]
  }
}

data "aws_security_group" "web-alb-sg" {
  filter {
    name   = "tag:Name"
    values = [var.web-alb-sg-name]
  }
}

data "aws_security_group" "app-alb-sg" {
  filter {
    name   = "tag:Name"
    values = [var.app-alb-sg-name]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc-name]
  }
}

# data "aws_acm_certificate" "cert" {
#   domain         = var.domain-name
# }