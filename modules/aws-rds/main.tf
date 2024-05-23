# # # 8개 시크릿 이름 변경 필요
# # resource "aws_secretsmanager_secret" "rds_master_secret3" {
# #   name = "rds-master-credentials3"

# #   tags = {
# #     "Name" = "rds-master-credentials3"
# #   }
# # }

# # resource "aws_secretsmanager_secret_version" "rds_master_secret_version" {
# #   secret_id = aws_secretsmanager_secret.rds_master_secret3.id

# #   secret_string = jsonencode({
# #     username = var.rds-username
# #     password = var.rds-pwd
# #   })
# # }


# # 8 Creating DB subnet group for RDS Instances
# resource "aws_db_subnet_group" "db_subnet_group" {
#   # name       = var.db-subnet-group-name
#   description = "Three-Tier-db-subnet-group"
#   subnet_ids = [data.aws_subnet.db-subnet1.id, data.aws_subnet.db-subnet2.id]
# }


# # Creating Aurora RDS Cluster, username and password used only for practice, otherwise follow DevOps best practices to keep it secret
# resource "aws_rds_cluster" "aurora_cluster" {
#   cluster_identifier      = "aurora-cluster"
#   engine                  = "aurora-mysql"
#   engine_version          = "8.0.mysql_aurora.3.06.0"
#   database_name           = var.db-name
#   port                    = 3306
#   master_username         = jsondecode(data.aws_secretsmanager_secret_version.rds_master_secret_version.secret_string)["username"]
#   master_password         = jsondecode(data.aws_secretsmanager_secret_version.rds_master_secret_version.secret_string)["password"]
#   db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
#   vpc_security_group_ids  = [data.aws_security_group.db-sg.id]
#   #enable_http_endpoint    = true  #Data API 활성화
#   backup_retention_period = 7
#   preferred_backup_window = "07:00-09:00"
#   skip_final_snapshot     = true
#   tags = {
#     Name = var.rds-name
#   }
# }


# # Creating RDS Cluster instance
# resource "aws_rds_cluster_instance" "primary_instance" {
#   cluster_identifier = aws_rds_cluster.aurora_cluster.id
#   identifier         = "primary-instance"
#   instance_class     = "db.t3.medium"
#   engine             = aws_rds_cluster.aurora_cluster.engine
#   engine_version     = aws_rds_cluster.aurora_cluster.engine_version
# }

# # Creating RDS Read Replica Instance
# resource "aws_rds_cluster_instance" "read_replica_instance" {
#   count              = 1
#   cluster_identifier = aws_rds_cluster.aurora_cluster.id
#   identifier         = "read-replica-instance-${count.index}"
#   instance_class     = "db.t3.medium"
#   engine             = aws_rds_cluster.aurora_cluster.engine

#   depends_on = [aws_rds_cluster_instance.primary_instance]
# }