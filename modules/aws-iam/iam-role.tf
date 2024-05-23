resource "aws_iam_role" "iam-role" {
  name               = var.iam-role
  assume_role_policy = file("./modules/aws-iam/iam-role.json")
} 

