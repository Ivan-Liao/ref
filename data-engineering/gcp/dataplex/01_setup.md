1. Create lake
```
gcloud dataplex lakes create orders-lake \
    --location=europe-west4 \
    --display-name="orders" \
    --description="Description of the lake" \
    --labels="key=value,key2=value2"

```
2. Create zone
```
# type is CURATED OR RAW
gcloud dataplex zones create customer-curated-zone \
    --lake=orders-lake \
    --location=europe-west4 \
    --type=CURATED \
    --resource-location-type=SINGLE_REGION \
    --display-name="Customer Curated Zone" \
    --description="curated customer data"
```
3. Create asset
```
gcloud dataplex assets create my-bucket-asset \
    --lake=my-lake \
    --zone=my-zone \
    --location=us-central1 \
    --resource-type=STORAGE_BUCKET \
    --resource-name=projects/my-project/buckets/my-gcs-bucket \
    --display-name="My GCS Asset" \
    --discovery-enabled


gcloud dataplex assets create customer-details-dataset \
    --lake=orders-lake \
    --zone=customer-curated-zone \
    --location=europe-west4 \
    --resource-type=BIGQUERY_DATASET \
    --resource-name="projects/qwiklabs-gcp-00-dee1fb7a1284/datasets/customers" \
    --display-name="Customer Details Dataset" \
    --discovery-enabled
```
4. Create aspects
   1. Apply aspects to zone assets or to individual assets schema columns
   2. enables search by aspect