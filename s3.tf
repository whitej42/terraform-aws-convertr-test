###################################### 
# S3 Bucket and associated resources #
######################################
resource "aws_s3_bucket" "file_upload_bucket" {
  bucket = "${local.env}-convertr-file-upload-bucket"

  tags = local.default_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "file_upload_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.file_upload_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = aws_kms_key.file_upload_kms_key.id
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "file_upload_bucket_ownership_controls" {
  bucket = aws_s3_bucket.file_upload_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "file_upload_bucket_policy" {
  bucket = aws_s3_bucket.file_upload_bucket.id
  policy = data.aws_iam_policy_document.file_upload_s3_policy.json
}

data "aws_iam_policy_document" "file_upload_s3_policy" {
  statement {
    sid    = "AllowLambdaAccessToBucket"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
        aws_iam_role.file_upload_lambda_role.arn
      ]
    }

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
}