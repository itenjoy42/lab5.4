resource "aws_iam_role_policy" "iam-policy" {
  name   = var.iam-policy
  role   = aws_iam_role.iam-role.id
  policy = file("./modules/aws-iam/iam-policy.json")
}