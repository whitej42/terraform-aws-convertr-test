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

# Network ACL
resource "aws_network_acl" "demo_private_acl" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = merge(local.default_tags, {
    Name = "Demo Private ACL"
  })
}

resource "aws_network_acl_association" "private_acl_association" {
  network_acl_id = aws_network_acl.demo_private_acl.id
  subnet_id = aws_subnet.demo_private_subnet.id
}

resource "aws_network_acl_rule" "private_inbound_ephemeral" {
  network_acl_id = aws_network_acl.demo_private_acl.id
  rule_number    = 100
  egress          = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_outbound_ephemeral" {
  network_acl_id = aws_network_acl.demo_private_acl.id
  rule_number    = 100
  egress          = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

# S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  vpc_id       = aws_vpc.demo_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.demo_private_route_table.id]

  tags = merge(local.default_tags,{
      Name = "${local.env}-s3-gateway-endpoint"
  })

  policy = jsonencode({
    Statement = {
      Principal = "*"
      Effect    = "Allow"
      Action    = "s3:*"
      Resource  = "${aws_s3_bucket.file_upload_bucket.arn}/*"
    }
  })
}