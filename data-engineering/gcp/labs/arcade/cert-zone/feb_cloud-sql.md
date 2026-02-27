1. Cloud SQL setup

```
git clone https://github.com/GoogleCloudPlatform/data-science-on-gcp/
cd data-science-on-gcp/03_sqlstudio
export PROJECT_ID=$(gcloud info \
    --format='value(config.project)') -- easier alternative $DEVSHELL_PROJECT_ID
export BUCKET=${PROJECT_ID}-ml


# copy from repo to bucket
gsutil cp create_table.sql \
    gs://$BUCKET/create_table.sql


# create Cloud SQL instance
gcloud sql instances create flights \
    --database-version=POSTGRES_13 --cpu=2 --memory=8GiB \
    --region=europe-west4 --root-password=Passw0rd

Created [https://sqladmin.googleapis.com/sql/v1beta4/projects/qwiklabs-gcp-03-6125f044f4fc/instances/flights].
NAME: flights
DATABASE_VERSION: POSTGRES_13
LOCATION: europe-west4-c
TIER: db-custom-2-8192
PRIMARY_ADDRESS: 35.234.171.108


# get Cloud Shell IP
export ADDRESS=$(curl -s \
    http://ipecho.net/plain)/32
# allow shell access to Cloud SQL
gcloud sql instances patch flights \
--authorized-networks $ADDRESS
```


2.  Analysis
```
gcloud sql connect flights --user=postgres
\c bts;

SELECT "Origin", COUNT(*) AS num_flights 
FROM flights GROUP BY "Origin" 
ORDER BY num_flights DESC 
LIMIT 5;
```