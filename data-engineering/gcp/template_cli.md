```
LOCATION_ZONE=YOUR_ZONE -- europe-west4-b
gcloud config set compute/zone $YOUR_ZONE


gcloud storage buckets create gs://qwiklabs-gcp-01-83c4633b6cba-bucket --location=$REGION --project=$(gcloud config get-value project) --default-storage-class=standard --uniform-bucket-level-access --public-access-prevention
```