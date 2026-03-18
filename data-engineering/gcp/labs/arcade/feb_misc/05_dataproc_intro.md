1. Configure environment in shell
```
# enable private IP access
gcloud compute networks subnets update default --region=us-west1 --enable-private-ip-google-access


# new gcs bucket for staging
gsutil mb -p  qwiklabs-gcp-01-054a7341a62b gs://qwiklabs-gcp-01-054a7341a62b


# new gcs bucket for bq temp processing creating and loading a table
gsutil mb -p  qwiklabs-gcp-01-054a7341a62b gs://qwiklabs-gcp-01-054a7341a62b-bqtemp


# bq dataset
bq mk -d  loadavro
```
2. Download avro file from VM
   1. SSH into the VM
```
wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro


# copy to gcs stage bucket
gcloud storage cp campaigns.avro gs://qwiklabs-gcp-01-054a7341a62b


# download archive with Spark code and prepare the code
wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/dataproc-templates.zip
unzip dataproc-templates.zip
cd dataproc-templates/python


# set env variables
export GCP_PROJECT=qwiklabs-gcp-01-054a7341a62b
export REGION=us-west1
export GCS_STAGING_LOCATION=gs://qwiklabs-gcp-01-054a7341a62b
export JARS=gs://cloud-training/dataengineering/lab_assets/idegc/spark-bigquery_2.12-20221021-2134.jar


# Execute GCS to BQ template 
./bin/start.sh \
-- --template=GCSTOBIGQUERY \
    --gcs.bigquery.input.format="avro" \
    --gcs.bigquery.input.location="gs://qwiklabs-gcp-01-054a7341a62b" \
    --gcs.bigquery.input.inferschema="true" \
    --gcs.bigquery.output.dataset="loadavro" \
    --gcs.bigquery.output.table="campaigns" \
    --gcs.bigquery.output.mode=overwrite\
    --gcs.bigquery.temp.bucket.name="qwiklabs-gcp-01-054a7341a62b-bqtemp"


# query from command line
bq query \
 --use_legacy_sql=false \
 'SELECT * FROM `loadavro.campaigns`;'
```