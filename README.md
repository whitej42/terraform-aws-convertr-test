# Secure File Upload via API Gateway, Lambda, and S3 with KMS Encryption
This solution enables secure file uploads to Amazon S3 using API Gateway and a private Lambda function. It leverages AWS-managed services with a security-first architecture, ensuring all traffic and data handling remain private and controlled.

## Architecture Overview
- API Gateway provides a public-facing REST endpoint to receive file uploads.

- Lambda (Private) handles decoding and validation of uploaded files, and securely stores them in S3. Runs within a VPC for added security.

- S3 Bucket (with KMS) stores uploaded files encrypted at rest using a Customer Managed Key (CMK).

- KMS CMK custom key allows fine-grained control — only the Lambda role and Terraform deployer role can use it to encrypt/decrypt.

- VPC Gateway Endpoint for S3 ensures all S3 traffic from Lambda stays within AWS’s private network, never traversing the public internet.

- IAM Roles follow least privilege, designed specifically for the Lambda execution, KMS encryption, and S3 access.

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
- Data Encryption Keys (DEKs) for true end-to-end encryption
- API key or IAM-based authorization on API Endpoint
- File-type filtering (e.g., allow only image types)
- Antivirus/malware scanning using tools like Amazon Macie or third-party Anti-Virus
- Frontend integration