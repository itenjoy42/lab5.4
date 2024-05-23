resource "aws_cloudfront_distribution" "cdn-alb-distribution" {
  origin {
    domain_name = var.web_alb_dns_name
    origin_id   = "Web-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = var.app_alb_dns_name
    origin_id   = "APP-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  aliases         = [var.domain-name, "*.${var.domain-name}"]
  enabled         = true
  price_class     = "PriceClass_100"

  default_cache_behavior {
    target_origin_id = "APP-alb"
    allowed_methods  = ["GET", "HEAD" ]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/static/*"
    target_origin_id = "Web-alb"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true 
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
  
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = aws_wafv2_web_acl.web_acl.arn

  tags = {
    Name = var.cdn-name
  }

}