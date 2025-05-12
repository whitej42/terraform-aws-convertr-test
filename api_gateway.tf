################
# API Gateways #
################
resource "aws_api_gateway_rest_api" "upload_rest_api" {
    name          = "${local.env}-convertrUploadApi"
    description = "Upload files via a Lambda"
}

# API Resource
resource "aws_api_gateway_resource" "upload_api_resource" {
    parent_id = aws_api_gateway_rest_api.upload_rest_api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.upload_rest_api.id
    path_part = "upload"
}

# POST Method
resource "aws_api_gateway_method" "upload_post_method" {
    rest_api_id = aws_api_gateway_rest_api.upload_rest_api.id
    resource_id = aws_api_gateway_resource.upload_api_resource.id
    http_method = "POST"
    authorization = "NONE"
}

# Integration with the Lambda
resource "aws_api_gateway_integration" "lambda_upload" {
  rest_api_id             = aws_api_gateway_rest_api.upload_rest_api.id
  resource_id             = aws_api_gateway_resource.upload_api_resource.id
  http_method             = aws_api_gateway_method.upload_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.file_upload_lambda_function.invoke_arn
}