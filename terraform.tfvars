# VPC
REGION           = "ap-northeast-1"
AZ_1             = "ap-northeast-1a"
AZ_2             = "ap-northeast-1c"

VPC-NAME         = "Three-Tier-VPC"
VPC-CIDR         = "192.168.0.0/16"
IGW-NAME         = "Three-Tier-Interet-Gateway"
PUBLIC-CIDR1     = "192.168.0.0/24"
PUBLIC-SUBNET1   = "Three-Tier-Public-Subnet1"
PUBLIC-CIDR2     = "192.168.10.0/24"
PUBLIC-SUBNET2   = "Three-Tier-Public-Subnet2"
WEB-CIDR1    = "192.168.20.0/24"
WEB-SUBNET1  = "Three-Tier-Web-Subnet1"
WEB-CIDR2    = "192.168.30.0/24"
WEB-SUBNET2  = "Three-Tier-Web-Subnet2"
APP-CIDR1    = "192.168.40.0/24"
APP-SUBNET1  = "Three-Tier-APP-Subnet1"
APP-CIDR2    = "192.168.50.0/24"
APP-SUBNET2  = "Three-Tier-APP-Subnet2"
DB-CIDR1    = "192.168.60.0/24"
DB-SUBNET1  = "Three-Tier-DB-Subnet1"
DB-CIDR2    = "192.168.70.0/24"
DB-SUBNET2  = "Three-Tier-DB-Subnet2"

EIP-NAME1        = "Three-Tier-Elastic-IP1"
EIP-NAME2        = "Three-Tier-Elastic-IP2"

NGW-NAME1        = "Three-Tier-NAT1"
NGW-NAME2        = "Three-Tier-NAT2"
PUBLIC-RT-NAME1  = "Three-Tier-Public-Route-table1"
# PUBLIC-RT-NAME2  = "Three-Tier-Public-Route-table2"
PRIVATE-RT-NAME1 = "Three-Tier-Private-Route-table1"
PRIVATE-RT-NAME2 = "Three-Tier-Private-Route-table2"
# PRIVATE-RT-NAME3 = "Three-Tier-Private-Route-table3"
# PRIVATE-RT-NAME4 = "Three-Tier-Private-Route-table4"


# SECURITY GROUP
WEB-ALB-SG-NAME = "Three-Tier-web-alb-sg"
APP-ALB-SG-NAME = "Three-Tier-app-alb-sg"
WEB-SG-NAME = "Three-Tier-web-sg"
APP-SG-NAME = "Three-Tier-app-sg"
DB-SG-NAME  = "Three-Tier-db-sg"
# DB-SUBNET-GROUP-NAME = "Three-Tier-db-subnet-group"

# RDS
# SG-NAME      = "Three-Tier-rds-sg"
# RDS-USERNAME = "admin"
# RDS-PWD      = "admin1234"
# DB-NAME      = "mydb"
# RDS-NAME     = "Three-Tier-RDS"

# ALB
WEB-TG-NAME  = "Web-TG"
APP-TG-NAME  = "APP-TG"
WEB-ALB-NAME = "Web-alb"
APP-ALB-NAME = "APP-alb"
PUBLIC-SUBNET-NAME1 = "Three-Tier-Public-Subnet-Name1"
PUBLIC-SUBNET-NAME2 = "Three-Tier-Public-Subnet-Name2"


# IAM
IAM-ROLE              = "iam-role-for-ec2-SSM"
IAM-POLICY            = "iam-policy-for-ec2-SSM"
INSTANCE-PROFILE-NAME = "iam-instance-profile-for-ec2-SSM"

# AUTOSCALING
#AMI-NAME             = "New-AMI"
APP-LAUNCH-TEMPLATE-NAME = "APP-template"
WEB-INSTANCE-TYPE        = "t4g.micro"
APP-INSTANCE-TYPE        = "t4g.micro"
APP-ASG-NAME             = "Three-Tier-APP-ASG"
WEB-SUBNET-NAME1 = "Three-Tier-Web-Subnet-Name1"
WEB-SUBNET-NAME2 = "Three-Tier-Web-Subnet-Name2"
APP-SUBNET-NAME1 = "Three-Tier-APP-Subnet-Name1"
APP-SUBNET-NAME2 = "Three-Tier-APP-Subnet-Name2"
# WEB-SERVER-ADDRESS       = ""
# WAS-SERVER-ADDRESS       = ""


# CLOUDFRONT
DOMAIN-NAME = "ticketjo.shop"
CDN-NAME    = "Three-Tier-CDN"
ALB-NAME    = "Web-alb"


# WAF
WEB-ACL-NAME = "Three-Tier-WAF"

#
