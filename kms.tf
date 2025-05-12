################################## 
# KMS Key, Alias and Key Policy #
##################################
resource "aws_kms_alias" "file_upload_kms_key_alias" {
  name          = "alias/s3/${aws_s3_bucket.file_upload_bucket.id}"
  target_key_id = aws_kms_key.file_upload_kms_key.id
}

resource "aws_kms_key" "file_upload_kms_key" {
  description              = "KMS key for encrypting ${aws_s3_bucket.file_upload_bucket.id} S3 bucket"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = true
  policy = data.aws_iam_policy_document.file_upload_kms_key_policy[0].json

  tags = local.default_tags
}

data "aws_iam_policy_document" "file_upload_kms_key_policy" {
  # Key owners - all key operations
  statement {
    sid       = "KeyOwner"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [
        data.aws_iam_role.terraform_role.arn
      ]
    }
  }

  # Key administrators
  statement {
    sid = "KeyAdministration"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:ReplicateKey",
      "kms:ImportKeyMaterial"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [
          aws_kms_alias.file_upload_kms_key_alias
        ]
    }
  }

  # Key service users 
  statement {
      sid = "KeyUsage"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
      ]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = [
          aws_iam_role.file_upload_lambda_role.arn
        ]
      }
    }
}