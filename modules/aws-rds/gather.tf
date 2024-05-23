data "aws_subnet" "db-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.db-subnet-name1]
  }
}

data "aws_subnet" "db-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.db-subnet-name2]
  }
}


data "aws_security_group" "db-sg" {
  filter {
    name   = "tag:Name"
    values = [var.db-sg-name]
  }
}

data "aws_secretsmanager_secret" "rds_master_secret0" {
  name = "rds-master-credentials0"
}

data "aws_secretsmanager_secret_version" "rds_master_secret_version" {
  secret_id = data.aws_secretsmanager_secret.rds_master_secret0.id
}

data "aws_secretsmanager_secret" "rds_master_secret0_existing" {
  name = "rds-master-credentials0"
}

data "aws_secretsmanager_secret_version" "rds_master_secret_version_existing" {
  secret_id = data.aws_secretsmanager_secret.rds_master_secret0_existing.id
}

# 변수로부터 비밀 값을 가져오기 위해 locals를 사용할 수 있습니다.
# locals {
#   rds_credentials = jsonencode({
#     username = var.rds-username
#     password = var.rds-pwd
#   })
# }

# output "rds_master_secret_string" {
#   value = local.rds_credentials
# }