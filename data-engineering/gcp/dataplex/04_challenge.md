1. dataplex lake with two zones and two assets
```
gcloud config set compute/region us-central1


gcloud dataplex lakes create sales-lake \
    --location=us-central1 \
    --display-name="Sales Lake" \
    --description="Description of the lake"


gcloud dataplex zones create raw-customer-zone \
    --lake=sales-lake \
    --location=us-central1 \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --display-name="Raw Customer Zone" \
    --description=""
gcloud dataplex zones create curated-customer-zone \
    --lake=sales-lake \
    --location=us-central1 \
    --type=CURATED \
    --resource-location-type=SINGLE_REGION \
    --display-name="Curated Customer Zone" \
    --description=""


gcloud dataplex assets create customer-engagements \
    --lake=sales-lake \
    --zone=raw-customer-zone \
    --location=us-central1 \
    --resource-type=STORAGE_BUCKET \
    --resource-name="projects/qwiklabs-gcp-01-10165582f8de/buckets/qwiklabs-gcp-01-10165582f8de-customer-online-sessions" \
    --display-name="Customer Engagements" \
    --discovery-enabled
gcloud dataplex assets create customer-orders \
    --lake=sales-lake \
    --zone=curated-customer-zone \
    --location=us-central1 \
    --resource-type=BIGQUERY_DATASET \
    --resource-name="projects/qwiklabs-gcp-01-10165582f8de/datasets/customer_orders" \
    --display-name="Customer Orders" \
    --discovery-enabled
```
2. Assign dataplex iam role
```
gcloud projects add-iam-policy-binding qwiklabs-gcp-01-10165582f8de \
    --member=user:student-00-f6b8b6b3fc4f@qwiklabs.net \
    --role=roles/dataplex.dataReader


gcloud dataplex assets add-iam-policy-binding customer-engagements \
    --location=us-central1 \
    --lake=sales-lake \
    --zone=raw-customer-zone \
    --member=user:student-00-f6b8b6b3fc4f@qwiklabs.net \
    --role=roles/dataplex.dataWriter
```
3. Data Quality
```
rules:
- nonNullExpectation: {}
  column: user_id
  dimension: COMPLETENESS
  threshold: 1
- nonNullExpectation: {}
  column: order_id
  dimension: COMPLETENESS
  threshold: 1
postScanActions:
  bigqueryExport:
    resultsTable: projects/qwiklabs-gcp-01-10165582f8de/datasets/orders_dq_dataset/tables/results

gsutil cp ./dq-customer-orders.yaml gs://qwiklabs-gcp-01-10165582f8de-dq-config

gcloud dataplex datascans create data-quality customer-orders-data-quality-job \
    --project=qwiklabs-gcp-01-10165582f8de \
    --location=us-central1 \
    --data-source-resource="//bigquery.googleapis.com/projects/qwiklabs-gcp-01-10165582f8de/datasets/customer_orders/tables/ordered_items" \
    --data-quality-spec-file="gs://qwiklabs-gcp-01-10165582f8de-dq-config/dq-customer-orders.yaml"
```