module "vpc" {
  source = "./modules/aws-vpc"

  region          = var.REGION
  az_1            = var.AZ_1
  az_2            = var.AZ_2

  vpc-name        = var.VPC-NAME
  vpc-cidr        = var.VPC-CIDR
  igw-name        = var.IGW-NAME
  public-cidr1    = var.PUBLIC-CIDR1
  public-subnet1  = var.PUBLIC-SUBNET1
  public-cidr2    = var.PUBLIC-CIDR2
  public-subnet2  = var.PUBLIC-SUBNET2
  web-cidr1   = var.WEB-CIDR1
  web-subnet1 = var.WEB-SUBNET1
  web-cidr2   = var.WEB-CIDR2
  web-subnet2 = var.WEB-SUBNET2
  app-cidr1   = var.APP-CIDR1
  app-subnet1 = var.APP-SUBNET1
  app-cidr2   = var.APP-CIDR2
  app-subnet2 = var.APP-SUBNET2
  db-cidr1    = var.DB-CIDR1
  db-subnet1  = var.DB-SUBNET1
  db-cidr2    = var.DB-CIDR2
  db-subnet2  = var.DB-SUBNET2

  eip-name1       = var.EIP-NAME1
  eip-name2       = var.EIP-NAME2

  ngw-name1        = var.NGW-NAME1
  ngw-name2        = var.NGW-NAME2
  public-rt-name1  = var.PUBLIC-RT-NAME1
  public-rt-name2  = var.PUBLIC-RT-NAME2
  private-rt-name1 = var.PRIVATE-RT-NAME1
  private-rt-name2 = var.PRIVATE-RT-NAME2
  private-rt-name3 = var.PRIVATE-RT-NAME3
  private-rt-name4 = var.PRIVATE-RT-NAME4
}

module "security-group" {
  source = "./modules/security-group"

  vpc-name    = var.VPC-NAME
  web-alb-sg-name = var.WEB-ALB-SG-NAME
  app-alb-sg-name = var.APP-ALB-SG-NAME
  web-sg-name = var.WEB-SG-NAME
  app-sg-name = var.APP-SG-NAME
  db-sg-name  = var.DB-SG-NAME

  depends_on = [module.vpc]
}

# module "rds" {
#   source = "./modules/aws-rds"

#   sg-name              = var.SG-NAME
#   db-subnet-name1 = var.DB-SUBNET1
#   db-subnet-name2 = var.DB-SUBNET2
#   db-sg-name           = var.DB-SG-NAME
#   rds-username         = var.RDS-USERNAME
#   rds-pwd              = var.RDS-PWD
#   db-name              = var.DB-NAME
#   rds-name             = var.RDS-NAME
#   db-subnet-group-name = var.DB-SUBNET-GROUP-NAME


#   depends_on = [module.security-group]
# }

module "alb" {
  source = "./modules/aws-alb"


  web-alb-sg-name     = var.WEB-ALB-SG-NAME
  app-alb-sg-name     = var.APP-ALB-SG-NAME
  web-alb-name        = var.WEB-ALB-NAME
  app-alb-name        = var.APP-ALB-NAME
  web-tg-name         = var.WEB-TG-NAME
  app-tg-name         = var.APP-TG-NAME
  vpc-name            = var.VPC-NAME
  domain-name         = var.DOMAIN-NAME
  # public-subnet-name1   = var.PUBLIC-SUBNET-NAME1
  # public-subnet-name2   = var.PUBLIC-SUBNET-NAME2
  public-subnet1  = var.PUBLIC-SUBNET1
  public-subnet2  = var.PUBLIC-SUBNET2

  depends_on = [module.security-group]
}

module "iam" {
  source = "./modules/aws-iam"

  iam-role              = var.IAM-ROLE
  iam-policy            = var.IAM-POLICY
  instance-profile-name = var.INSTANCE-PROFILE-NAME

  depends_on = [module.alb]
}

module "autoscaling" {
  source = "./modules/aws-autoscaling"

  #ami_name              = var.AMI-NAME
  app-launch-template-name  = var.APP-LAUNCH-TEMPLATE-NAME
  web-instance-type         = var.WEB-INSTANCE-TYPE
  app-instance-type         = var.APP-INSTANCE-TYPE
  #instance-profile-name = var.INSTANCE-PROFILE-NAME
  web-subnet1 = var.WEB-SUBNET1
  web-subnet2 = var.WEB-SUBNET2
  app-subnet1    = var.APP-SUBNET1
  app-subnet2    = var.APP-SUBNET2
  app-asg-name              = var.APP-ASG-NAME
  web-sg-name               = var.WEB-SG-NAME
  app-sg-name               = var.APP-SG-NAME  
  web-tg-name               = var.WEB-TG-NAME
  app-tg-name               = var.APP-TG-NAME
  #iam-role              = var.IAM-ROLE
  # web_server_address = var.WEB-SERVER-ADDRESS
  # was_server_address = var.WAS-SERVER-ADDRESS

  depends_on = [module.iam]
}

module "waf-cdn-acm-route53" {
  source = "./modules/aws-waf-cdn-acm-route53"

  domain-name  = var.DOMAIN-NAME
  cdn-name     = var.CDN-NAME
  web_alb_dns_name = module.alb.web_alb_dns_name
  app_alb_dns_name = module.alb.app_alb_dns_name
  web_acl_name = var.WEB-ACL-NAME
  web-alb-name = var.WEB-ALB-NAME
  app-alb-name = var.APP-ALB-NAME

  providers = {
    aws = aws.us-east-1
  }

  depends_on = [ module.alb ]
}