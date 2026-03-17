1. Create lake
```
gcloud dataplex lakes create customer-info-lake \
    --location=europe-west4 \
    --display-name="Customer Info Lake" \
    --description="Description of the lake"
```
2. Create zone
```
# type is CURATED OR RAW
gcloud dataplex zones create customer-raw-zone \
    --lake=customer-info-lake \
    --location=europe-west4 \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --display-name="Customer Raw Zone" \
    --description="curated customer data"
```
3. Create asset
```
gcloud dataplex assets create customer-online-sessions \
    --lake=customer-info-lake \
    --zone=customer-raw-zone \
    --location=europe-west4 \
    --resource-type=STORAGE_BUCKET \
    --resource-name=projects/qwiklabs-gcp-02-a6b07a55115a/buckets/qwiklabs-gcp-02-a6b07a55115a-bucket \
    --display-name="Customer Online Sessions" \
    --discovery-enabled
```
4. Security access
```
gcloud projects add-iam-policy-binding qwiklabs-gcp-02-a6b07a55115a \
    --member=user:student-03-514f96dc0533@qwiklabs.net \
    --role=roles/dataplex.dataReader


gcloud dataplex assets add-iam-policy-binding customer-online-sessions \
    --location=europe-west4 \
    --lake=customer-info-lake \
    --zone=customer-raw-zone \
    --member=user:student-03-514f96dc0533@qwiklabs.net \
    --role=roles/dataplex.dataReader
gcloud dataplex assets add-iam-policy-binding customer-online-sessions \
    --location=europe-west4 \
    --lake=customer-info-lake \
    --zone=customer-raw-zone \
    --member=user:student-03-514f96dc0533@qwiklabs.net \
    --role=roles/dataplex.dataWriter
```