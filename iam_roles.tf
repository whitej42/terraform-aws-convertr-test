#############
# IAM Roles #
#############
resource "aws_iam_role" "file_upload_lambda_role" {
    name = "${local.env}-convertrFileUpload-role"
    description = "Role to allow Lambda to read and write to file upload bucket"
     tags = local.default_tags

    assume_role_policy = jsondecode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}