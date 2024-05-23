

# Creating ALB for Web Tier
resource "aws_lb" "web-alb" {
  load_balancer_type = "application"
  name = var.web-alb-name
  internal           = false
  ip_address_type    = "ipv4"
  subnets            = [data.aws_subnet.public-subnet1.id, data.aws_subnet.public-subnet2.id]
  security_groups    = [data.aws_security_group.web-alb-sg.id]
  enable_deletion_protection = false
  
  tags = {
    Name = var.web-alb-name
  }
}

# Creating Target Group for Web-Tier 
resource "aws_lb_target_group" "web-tg" {
  target_type = "instance"
  name = var.web-tg-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
  health_check {
    enabled = true
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = var.web-tg-name
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  } 
  depends_on = [ aws_lb.web-alb ]
}


# Creating ALB listener with port 80 and attaching it to Web-Tier Target Group
resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }

  #certificate_arn      = data.aws_acm_certificate.cert.arn

  depends_on = [ aws_lb.web-alb ]
}

# Creating ALB for APP Tier
resource "aws_lb" "app-alb" {   
  name = var.app-alb-name
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public-subnet1.id, data.aws_subnet.public-subnet2.id]
  security_groups    = [data.aws_security_group.app-alb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    Name = var.app-alb-name
  }

  depends_on = [ aws_lb.web-alb ] ###
}

# Creating Target Group for APP-Tier 
resource "aws_lb_target_group" "app-tg" {
  name = var.app-tg-name
  health_check {
    enabled = true
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name = var.app-tg-name
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  } 
  depends_on = [ aws_lb.app-alb ]
}


# Creating ALB listener with port 80 and attaching it to APP-Tier Target Group
resource "aws_lb_listener" "app-alb-listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }

  #certificate_arn      = data.aws_acm_certificate.cert.arn

  depends_on = [ aws_lb.app-alb ]
}