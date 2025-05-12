resource "aws_security_group" "file_upload_lambda_sg" {
    name = "${local.env}-fileUploadLambda-sg"

    tags = local.default_tags
}