1. Create bucket, upload image, share image
```
# GCS
REGION=us-east1
gcloud config set project qwiklabs-gcp-02-33632c6dfabb
gcloud storage buckets create gs://qwiklabs-gcp-02-33632c6dfabb-bucket --location=$REGION --project=$(gcloud config get-value project) --default-storage-class=standard
gcloud storage cp ./kitten.png gs://qwiklabs-gcp-02-33632c6dfabb-bucket

gcloud storage buckets add-iam-policy-binding gs://qwiklabs-gcp-02-33632c6dfabb-bucket \
    --member="allUsers" \
    --role="roles/storage.objectViewer"
gcloud storage objects update gs://qwiklabs-gcp-02-33632c6dfabb-bucket/kitten.png --add-acl-grant=entity=allUsers,role=READER

https://storage.googleapis.com/qwiklabs-gcp-02-33632c6dfabb-bucket/kitten.png


echo "" | gcloud storage cp - gs://qwiklabs-gcp-02-33632c6dfabb-bucket/folder1/ # echo "" creates an empty file
echo "" | gcloud storage cp - gs://qwiklabs-gcp-02-33632c6dfabb-bucket/folder1/folder2/ # echo "" creates an empty file
gcloud storage cp ./kitten.png gs://qwiklabs-gcp-02-33632c6dfabb-bucket/folder1/folder2/kitten.png
```