resource "aws_cloudwatch_log_group" "file_upload_lambda_log_group" {
  log_group_class = "STANDARD"
  name = "lambda/${local.env}-convertrFileUpload-function"
  retention_in_days = 0
  skip_destroy = true
  tags = local.default_tags
}