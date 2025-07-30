from secrets import AWS_S3_ID, AWS_S3_PASSWORD

import boto3
import os

client = boto3.client('s3',
    aws_access_key_id = AWS_S3_ID,
    aws_secret_access_key = AWS_S3_PASSWORD
    )

for file in os.listdir():
    if '.py' in file and not file.endswith('secrets.py'):
        upload_file_bucket = 'ihl-reference'
        upload_file_key = 'python/' + str(file)
        client.upload_file(file, upload_file_bucket, upload_file_key) # current file path, upload bucket name, upload full path