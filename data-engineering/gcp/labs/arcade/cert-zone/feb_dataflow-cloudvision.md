1. Dataflow job PubSub to BQ
```
gcloud config set compute/region us-west1

gcloud services disable dataflow.googleapis.com
gcloud services enable dataflow.googleapis.com

gcloud storage buckets create gs://qwiklabs-gcp-03-5a08f5510157-bucket --project=$(gcloud config get-value project) --default-storage-class=standard --location=US --uniform-bucket-level-access

docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID python:3.9 /bin/bash

pip install 'apache-beam[gcp]'==2.67.0
python -m apache_beam.examples.wordcount --output OUTPUT_FILE

BUCKET=gs://qwiklabs-gcp-03-5a08f5510157-bucket

python -m apache_beam.examples.wordcount --project $DEVSHELL_PROJECT_ID \
  --runner DataflowRunner \
  --staging_location $BUCKET/staging \
  --temp_location $BUCKET/temp \
  --output $BUCKET/results/output \
  --region us-west1
```
2. Qwik Start
   1. Setup bucket and upload image
```
# with acl enabled
gcloud storage buckets create gs://qwiklabs-gcp-02-a8e12fdab2c2-bucket --project=$(gcloud config get-value project) --default-storage-class=standard --location=US

gsutil acl ch -u AllUsers:R gs://qwiklabs-gcp-02-a8e12fdab2c2-bucket/demo-image.jpg
```
   2. Request to Cloud Vision API
      1. REST Reference >> v1 >> images >> annotate
   3. Example output
```
{
  "responses": [
    {
      "labelAnnotations": [
        {
          "mid": "/m/0bt9lr",
          "description": "Dog",
          "score": 0.9955614,
          "topicality": 0.5910274
        },
        {
          "mid": "/m/01lrl",
          "description": "Carnivores",
          "score": 0.95821124,
          "topicality": 0.006677204
        },
        {
          "mid": "/m/05mqq3",
          "description": "Snout",
          "score": 0.8904693,
          "topicality": 0.0051104086
        },
        {
          "mid": "/m/0h8ks17",
          "description": "Pet Supply",
          "score": 0.84506834,
          "topicality": 0.0013254747
        },
        {
          "mid": "/m/09141t",
          "description": "Collar",
          "score": 0.83984137,
          "topicality": 0.015019552
        },
        {
          "mid": "/m/07_gml",
          "description": "Working animal",
          "score": 0.8320223,
          "topicality": 0.000209493
        },
        {
          "mid": "/m/01v327",
          "description": "Lawn",
          "score": 0.829867,
          "topicality": 0.006828101
        },
        {
          "mid": "/m/01z5f",
          "description": "Canidae",
          "score": 0.78751886,
          "topicality": 0.010690784
        },
        {
          "mid": "/m/05q778",
          "description": "Dog collar",
          "score": 0.78325343,
          "topicality": 0.008057055
        },
        {
          "mid": "/m/0h8nm96",
          "description": "Dog Supply",
          "score": 0.73061556,
          "topicality": 0.0014571295
        }
      ]
    }
  ]
}
```