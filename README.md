# Secure File Upload via API Gateway, Lambda, and S3 with KMS Encryption
This solution enables secure file uploads to Amazon S3 using API Gateway and a private Lambda function. It leverages AWS-managed services with a security-first architecture, ensuring all traffic and data handling remain private and controlled.

## Architecture Overview
- API Gateway
Provides a public-facing REST endpoint to receive file uploads.

- Lambda (Private)
Handles decoding and validation of uploaded files, and securely stores them in S3. Runs within a VPC for added security.

- S3 Bucket (with KMS)
Stores uploaded files encrypted at rest using a Customer Managed Key (CMK).

- KMS CMK
Custom key allows fine-grained control — only the Lambda role and Terraform deployer role can use it to encrypt/decrypt.

- VPC Gateway Endpoint for S3
Ensures all S3 traffic from Lambda stays within AWS’s private network, never traversing the public internet.

- IAM Roles
Roles follow least privilege, designed specifically for the Lambda execution, KMS encryption, and S3 access.

## Testing via Postman
- Method: POST

- URL:
    - https://y6iuuw74r6.execute-api.us-east-1.amazonaws.com/dev/upload

- Params
    - filename: <your_file_name.ext>

- Body:
    - Select binary in Postman
    - Choose the file you want to upload

## Pipeline Deployments
GitHub Actions is used to deploy the Terraform code to AWS via the automated pipeline. OpenID Connect is used to assume a specific Terraform IAM Role in AWS to deploy infrastructure.

##  Future Enhancements
- API key enforcement or IAM-based authorization
- File-type filtering (e.g., allow only image MIME types)
- Antivirus/malware scanning using tools like Amazon Macie or third-party AV
- Frontend integration for drag-and-drop or form-based uploads