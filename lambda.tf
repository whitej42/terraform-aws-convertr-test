####################
# Lambda Functions #
####################

# Zip Codebase
data "archive_file" "file_upload_lambda_zip" {
  type = "zip"
  source_dir = "${path.module}/src/lambda/file_upload"
  output_path = "${path.module}/src/lambda/file_upload.zip"
}

# Function
resource "aws_lambda_function" "file_upload_lambda_function" {
    function_name = "${local.env}-convertrFileUpload-function"
    filename = data.archive_file.file_upload_lambda_zip.output_path
    source_code_hash = data.archive_file.file_upload_lambda_zip.output_base64sha256
    architectures = [ "x86_64" ]
    handler = "file_upload.lambda_handler"
    package_type = "Zip"
    runtime = "python3.12"
    role = aws_iam_role.file_upload_lambda_role.arn

    vpc_config {
        subnet_ids         = [aws_subnet.demo_private_subnet.id]
        security_group_ids = [aws_security_group.lambda_sg.id]
    }

    environment {
      variables = {
        BUCKET_NAME = aws_s3_bucket.file_upload_bucket.id
      }
    }

    tags = local.default_tags
}

# API Permissions
resource "aws_lambda_permission" "file_upload_lambda_api_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_upload_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.upload_rest_api.execution_arn}/*/POST/*"
}