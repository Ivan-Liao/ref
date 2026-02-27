1. Config
```
gcloud config set compute/region europe-west4

gcloud storage buckets create gs://qwiklabs-gcp-01-56c56e288cc4-bucket --project=$(gcloud config get-value project) --default-storage-class=standard --location=US --uniform-bucket-level-access

docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID python:3.9 /bin/bash

pip install 'apache-beam[gcp]'==2.67.0
python -m apache_beam.examples.wordcount --output OUTPUT_FILE

python -m apache_beam.examples.wordcount --project $DEVSHELL_PROJECT_ID \
  --runner DataflowRunner \
  --staging_location $BUCKET/staging \
  --temp_location $BUCKET/temp \
  --output $BUCKET/results/output \
  --region europe-west4
```