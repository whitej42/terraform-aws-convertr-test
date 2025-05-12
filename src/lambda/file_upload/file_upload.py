import json
import boto3
import base64
import os

s3 = boto3.client("s3")
bucket_name = os.environ["BUCKET_NAME"]

def lambda_handler(event, context):
    try:
        file_content = base64.b64decode(event["body"])
        filename = event.get("queryStringParameters", {}).get("filename")

        s3.put_object(
            Bucket=bucket_name,
            Key=filename,
            Body=file_content,
            ServerSideEncryption='aws:kms'
        )

        return {
            "statusCode": 200,
            "body": f"File {filename} uploaded successfully"
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": str(e)
        }