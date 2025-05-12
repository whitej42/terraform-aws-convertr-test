import json
import boto3
import base64
import os
import filetype

s3 = boto3.client('s3')
BUCKET_NAME = os.environ.get('BUCKET_NAME')

ALLOWED_IMAGE_MIME_TYPES = {"image/jpeg", "image/png", "image/gif", "image/webp"}

def handler(event, context):
    try:
        body = json.loads(event['body'])
        filename = body.get('filename')
        content_base64 = body.get('content')

        if not filename or not content_base64:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Missing 'filename' or 'content'"})
            }

        # Decode base64 content
        file_content = base64.b64decode(content_base64)

        # Use filetype to detect MIME type
        kind = filetype.guess(file_content)
        if kind is None or kind.mime not in ALLOWED_IMAGE_MIME_TYPES:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Only valid image uploads are allowed."})
            }

        # Upload to S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=file_content,
            ContentType=kind.mime
            ServerSideEncryption='aws:kms'
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"Image '{filename}' uploaded successfully."})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }