###############
# IAM Polices #
###############
resource "aws_iam_policy" "file_upload_lambda_role_policy" {
    name = "${local.env}-convertrFileUpload-S3-policy"
    tags = local.default_tags

    policy = data.aws_iam_policy_document.file_upload_iam_policy[0].json
}

data "aws_iam_policy_document" "file_upload_iam_policy" {
  statement {
    sid    = "AllowLambdaAccessToBucket"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.file_upload_bucket.arn,
      "${aws_s3_bucket.file_upload_bucket.arn}/*"
    ]
  }

  statement {
    sid = "AllowCloudWatchLogsAccess"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = aws_cloudwatch_log_group.file_upload_lambda_log_group.arn
  }
}