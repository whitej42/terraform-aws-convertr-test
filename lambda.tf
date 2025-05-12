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
    handler = "index.handler"
    package_type = "Zip"
    runtime = "python3.12"
    role = aws_iam_role.file_upload_lambda_role.arn

    tags = local.default_tags
}

# API Permissions
resource "aws_lambda_permission" "file_upload_lambda_api_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_upload_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${aws_api_gateway_rest_api.upload_rest_api.execution_arn}/*/*"
}

# Layers for additional Python packages
resource "aws_lambda_layer_version" "filetype_lambda_layer" {
  filename   = "${path.module}/src/lambda/file_upload/filetype_layer"
  layer_name = "filetype_layer_name"

  compatible_runtimes = ["python3.13"]
}