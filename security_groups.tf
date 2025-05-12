resource "aws_security_group" "file_upload_lambda_sg" {
    name = "${local.env}-fileUploadLambda-sg"
    description = "Allow Lambda Function to Upload via S3 Endpoint"
    vpc_id = aws_vpc.demo_vpc.id

    tags = merge(local.default_tags,{
        Name = "${local.env}-fileUploadLambda-sg"
    })
}

resource "aws_vpc_security_group_egress_rule" "egress_allow_tcp_all" {
  security_group_id = aws_security_group.file_upload_lambda_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  to_port     = 65535
  ip_protocol = "tcp"
}