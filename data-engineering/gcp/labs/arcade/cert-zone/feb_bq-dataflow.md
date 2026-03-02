1. Config
```
gcloud services disable dataflow.googleapis.com --project Project ID --force
gcloud services enable dataflow.googleapis.com --project Project ID
```
2. Object setup
```
bq mk taxirides
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime

export BUCKET_NAME=qwiklabs-gcp-03-0aa5dcce203c
gsutil mb gs://$BUCKET_NAME/
```
3. Dataflow run
```
gcloud dataflow jobs run iotflow \
    --gcs-location gs://dataflow-templates-"Region"/latest/PubSub_to_BigQuery \
    --region "Region" \
    --worker-machine-type e2-medium \
    --staging-location gs://"Bucket Name"/temp \
    --parameters inputTopic=projects/pubsub-public-data/topics/taxirides-realtime,outputTableSpec="Table Name":taxirides.realtime
```
4. Query
```
SELECT * FROM `"Bucket Name".taxirides.realtime` LIMIT 1000
```