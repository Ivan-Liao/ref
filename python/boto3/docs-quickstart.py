import boto3
from secrets import AWS_S3_ID, AWS_S3_PASSWORD

'''
Configuration
'''
s3 = boto3.resource('s3',
    aws_access_key_id = AWS_S3_ID,
    aws_secret_access_key = AWS_S3_PASSWORD
    )

'''
Functions
'''

# list all buckets
for bucket in s3.buckets.all():
    print(bucket.name)

# upload a binary jpg
with open('test.jpg', 'rb') as data:
    s3.Bucket('ihl-media').put_object(Key='test.jpg', Body=data)