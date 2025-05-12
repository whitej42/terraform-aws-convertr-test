resource "aws_security_group" "file_upload_lambda_sg" {
    name = "${local.env}-fileUploadLambda-sg"
    description = "Allow Lambda Function to Upload via S3 Endpoint"
    vpc_id = aws_vpc.demo_vpc.id

    tags = merge(local.default_tags,{
        Name = "${local.env}-fileUploadLambda-sg"
    })
}