output "api_url" {
  value = "${aws_api_gateway_deployment.upload_deployment.invoke_url}/upload"
}