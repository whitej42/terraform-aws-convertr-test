# VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = var.cidr_block

  tags = merge(local.default_tags, {
    Name = "Demo VPC"
  })
}

# Private Subnet
resource "aws_subnet" "demo_private_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = var.private_subnet_cidr

    tags = merge(local.default_tags, {
      Name = "Demo Private Subnet"
  })
}

# Route Table
resource "aws_route_table" "demo_private_route_table" {
    vpc_id = aws_vpc.demo_vpc.id

    tags = merge(local.default_tags, {
      Name = "Demo Private Route Table"
  })
}

# Route Table Association
resource "aws_route_table_association" "demo_private_subnet_association" {
  subnet_id      = aws_subnet.demo_private_subnet.id
  route_table_id = aws_route_table.demo_private_route_table.id
}

# S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  vpc_id       = aws_vpc.demo_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.demo_private_route_table.id]
  tags = local.default_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect    = "Allow"
      Action    = "s3:*"
      Resource  = "${aws_s3_bucket.file_upload_bucket.arn}/*"
    }
  })
}