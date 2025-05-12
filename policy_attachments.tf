######################
# Policy Attachments #
######################
resource "aws_iam_role_policy_attachment" "file_upload_lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.file_upload_lambda_role_policy.arn
  role = aws_iam_role.file_upload_lambda_role.name
}