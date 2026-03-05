1. Setup
```
# Create bucket
gcloud storage buckets create gs://qwiklabs-gcp-03-1e5007d6c179-bucket --location=$REGION --project=$(gcloud config get-value project) --default-storage-class=standard --uniform-bucket-level-access --public-access-prevention
gcloud storage cp ./YOUR_FILE_PATH gs://YOUR_FOLDER_PATH/


gcloud projects remove-iam-policy-binding qwiklabs-gcp-03-1e5007d6c179 \
    --member="user:student-01-005e3321ecf6@qwiklabs.net" \
    --role="roles/storage.objectViewer"


gcloud storage buckets add-iam-policy-binding gs://qwiklabs-gcp-03-1e5007d6c179-bucket \
    --member="user:student-01-005e3321ecf6@qwiklabs.net" \
    --role="roles/storage.objectViewer"


gcloud projects get-iam-policy qwiklabs-gcp-03-1e5007d6c179 --filter="bindings.members:student-01-005e3321ecf6@qwiklabs.net"
```