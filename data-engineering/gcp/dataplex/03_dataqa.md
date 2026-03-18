1. setup
```
gcloud dataplex lakes create ecommerce-lake \
    --location=europe-west4 \
    --display-name="Ecommerce Lake" \
    --description="Description of the lake"


# type is CURATED OR RAW
gcloud dataplex zones create customer-contact-raw-zone \
    --lake=ecommerce-lake \
    --location=europe-west4 \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --display-name="Customer Contact Raw Zone" \
    --description=""


gcloud dataplex assets create contact-info \
    --lake=ecommerce-lake \
    --zone=customer-contact-raw-zone \
    --location=europe-west4 \
    --resource-type=BIGQUERY_DATASET \
    --resource-name="projects/qwiklabs-gcp-01-8543c11be25c/datasets/customers" \
    --display-name="Contact Info" \
    --discovery-enabled
```
2. Create Cloud DQ check
   1. Create yaml file for quality check job and run it
```
rules:
- nonNullExpectation: {}
  column: id
  dimension: COMPLETENESS
  threshold: 1
- regexExpectation:
    regex: '^[^@]+[@]{1}[^@]+$'
  column: email
  dimension: CONFORMANCE
  ignoreNull: true
  threshold: .85
postScanActions:
  bigqueryExport:
    resultsTable: projects/qwiklabs-gcp-01-8543c11be25c/datasets/customers_dq_dataset/tables/dq_results

Dataplex >> Govern >> Data Profiling & Quality >> Create data quality scan
```
   1. Use bigquery to analyze failed rows, query automatically generated in rule_failed_records_query
```
WITH `5e030b9c-e555-436d-ae11-ac6626cfe73e` AS (SELECT * FROM `qwiklabs-gcp-01-8543c11be25c.customers.contact_info` ) SELECT * FROM `5e030b9c-e555-436d-ae11-ac6626cfe73e` WHERE (NOT(REGEXP_CONTAINS(`email`, r'^[^@]+[@]{1}[^@]+$')));
```