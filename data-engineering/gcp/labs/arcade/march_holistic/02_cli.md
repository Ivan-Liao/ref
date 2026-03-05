1. Setup
```
YOUR_BUCKET_NAME=qwiklabs-gcp-03-c6b9347bca20
gcloud storage buckets create gs://qwiklabs-gcp-03-c6b9347bca20
curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg
# local to gcs
gcloud storage cp ada.jpg gs://$YOUR_BUCKET_NAME
rm ada.jpg
# gcs to local
gcloud storage cp -r gs://$YOUR_BUCKET_NAME/ada.jpg .


gcloud storage cp gs://$YOUR_BUCKET_NAME/ada.jpg gs://$YOUR_BUCKET_NAME/image-folder/
gcloud storage ls gs://$YOUR_BUCKET_NAME
gcloud storage ls -l gs://$YOUR_BUCKET_NAME/ada.jpg
gcloud storage objects update gs://$YOUR_BUCKET_NAME/ada.jpg --add-acl-grant=entity=allUsers,role=READER
https://storage.googleapis.com/$YOUR_BUCKET_NAME/ada.jpg
```