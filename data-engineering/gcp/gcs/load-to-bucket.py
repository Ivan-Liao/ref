# Import the Cloud Storage library
from google.cloud import storage

# Function to upload a file to a bucket
def upload_blob(bucket_name, source_file_name, destination_blob_name):
    
    # Create a client to interact with Storage
    storage_client = storage.Client()
    
    # Get the specific bucket
    bucket = storage_client.bucket(bucket_name)
    
    # Define the file's path and name in the bucket
    blob = bucket.blob(destination_blob_name)
    
    # Upload the file from your computer
    blob.upload_from_filename(source_file_name)
    
    # Confirm the upload
    print(f"File {source_file_name} uploaded to {destination_blob_name} in bucket {bucket_name}.")