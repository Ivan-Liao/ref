1. Prep
```
-- check loan application data
gcloud storage cat gs://qwiklabs-gcp-01-d4756b127df3-input-bucket/source/loan_applications.csv | head -n 6

-- enable dataflow and bigquery apis
gcloud services enable dataflow.googleapis.com bigquery.googleapis.com
```
2. Build dataflow job
```
read_load_apps (CSV from Cloud Storage)
filter_for_approved (Filter Python)
write_to_bigquery (BigQuery Table)

-- configure regional endpoint
-- configure temporary and staging locations to gcs
```
3. Analyze in Bigquery
```
SELECT count(*) as total_records FROM `qwiklabs-gcp-01-d4756b127df3.loan_data.approved_loans`;


SELECT * FROM `qwiklabs-gcp-01-d4756b127df3.loan_data.approved_loans` LIMIT 10;
```