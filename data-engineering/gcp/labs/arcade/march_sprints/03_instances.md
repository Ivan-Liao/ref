1. Setup
```
LOCATION_ZONE=YOUR_ZONE -- europe-west4-b
gcloud config set compute/zone $YOUR_ZONE


gcloud storage buckets create gs://qwiklabs-gcp-01-83c4633b6cba-bucket --location=$REGION --project=$(gcloud config get-value project) --default-storage-class=standard --uniform-bucket-level-access --public-access-prevention
```
2. Instance setup
   1. Templating
   2. Group creation
   3. Configure autoscaling
3. Autoscaling example