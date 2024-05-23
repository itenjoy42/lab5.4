# VPC
variable "REGION" {}
variable "AZ_1" {}
variable "AZ_2" {}

variable "VPC-NAME" {}
variable "VPC-CIDR" {}
variable "IGW-NAME" {}
variable "PUBLIC-CIDR1" {}
variable "PUBLIC-SUBNET1" {}
variable "PUBLIC-CIDR2" {}
variable "PUBLIC-SUBNET2" {}
variable "WEB-CIDR1" {}
variable "WEB-SUBNET1" {}
variable "WEB-CIDR2" {}
variable "WEB-SUBNET2" {}
variable "APP-CIDR1" {}
variable "APP-SUBNET1" {}
variable "APP-CIDR2" {}
variable "APP-SUBNET2" {}
variable "DB-CIDR1" {}
variable "DB-SUBNET1" {}
variable "DB-CIDR2" {}
variable "DB-SUBNET2" {}

variable "EIP-NAME1" {}
variable "EIP-NAME2" {}

variable "NGW-NAME1" {}
variable "NGW-NAME2" {}
variable "PUBLIC-RT-NAME1" {}
variable "PUBLIC-RT-NAME2" {}
variable "PRIVATE-RT-NAME1" {}
variable "PRIVATE-RT-NAME2" {}
variable "PRIVATE-RT-NAME3" {}
variable "PRIVATE-RT-NAME4" {}

# SECURITY GROUP
variable "WEB-ALB-SG-NAME" {}
variable "APP-ALB-SG-NAME" {}
variable "WEB-SG-NAME" {}
variable "APP-SG-NAME" {}
variable "DB-SG-NAME" {}

# RDS
# variable "SG-NAME" {}
# variable "RDS-USERNAME" {}
# variable "RDS-PWD" {}
# variable "DB-NAME" {}
# variable "RDS-NAME" {}
# variable "DB-SUBNET-GROUP-NAME" {}


# ALB
variable "WEB-TG-NAME" {}
variable "APP-TG-NAME" {}
variable "WEB-ALB-NAME" {}
variable "APP-ALB-NAME" {}
variable "PUBLIC-SUBNET-NAME1" {}
variable "PUBLIC-SUBNET-NAME2" {}

# IAM
variable "IAM-ROLE" {}
variable "IAM-POLICY" {}
variable "INSTANCE-PROFILE-NAME" {}

# AUTOSCALING
#variable "AMI-NAME" {}
variable "APP-LAUNCH-TEMPLATE-NAME" {}
variable "WEB-INSTANCE-TYPE" {}
variable "APP-INSTANCE-TYPE" {}
variable "APP-ASG-NAME" {}
variable "WEB-SUBNET-NAME1" {}
variable "WEB-SUBNET-NAME2" {}
variable "APP-SUBNET-NAME1" {}
variable "APP-SUBNET-NAME2" {}
# variable "WEB-SERVER-ADDRESS" {}
# variable "WAS-SERVER-ADDRESS" {}


# CLOUDFFRONT
variable "DOMAIN-NAME" {}
variable "CDN-NAME" {}
variable "ALB-NAME" {}


# WAF
variable "WEB-ACL-NAME" {}

# ROUTE53





# variable "" {}
# variable "" {}
# variable "" {}
# variable "" {}
# variable "" {}
# variable "" {}
# variable "" {}
# variable "" {}