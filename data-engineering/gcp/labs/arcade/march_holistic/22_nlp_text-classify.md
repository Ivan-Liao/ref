1. Setup
```
gcloud services enable language.googleapis.com
gcloud iam service-accounts create my-nlp-sa \
  --display-name "my natural language service account"
gcloud iam service-accounts keys create ~/key.json \
  --iam-account  my-nlp-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS="/home/USER/key.json"
```
2. Classify text
```
{
  "document":{
    "type":"PLAIN_TEXT",
    "content":"A Smoky Lobster Salad With a Tapa Twist. This spin on the Spanish pulpo a la gallega skips the octopus, but keeps the sea salt, olive oil, pimentón and boiled potatoes."
  }
}
curl "https://language.googleapis.com/v1/documents:classifyText?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @request.json > result.json


gsutil cat gs://spls/gsp063/bbc_dataset/entertainment/001.txt

bq mk new_classification_dataset
bq mk \
--schema \
article_text:string,\
category:string,\
confidence:float\
 -t news_classification_dataset.article_data


export PROJECT=Project ID
gcloud iam service-accounts create my-account --display-name my-account
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:my-account@$PROJECT.iam.gserviceaccount.com --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:my-account@$PROJECT.iam.gserviceaccount.com --role=roles/serviceusage.serviceUsageConsumer
gcloud iam service-accounts keys create key.json --iam-account=my-account@$PROJECT.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS=key.json
python3 classify-text.py
```    
```
# python program

from google.cloud import storage, language, bigquery

# Set up your GCS, NL, and BigQuery clients

storage_client = storage.Client()
nl_client = language.LanguageServiceClient()
bq_client = bigquery.Client(project='Project ID')

dataset_ref = bq_client.dataset('news_classification_dataset')
dataset = bigquery.Dataset(dataset_ref)
table_ref = dataset.table('article_data')
table = bq_client.get_table(table_ref)

# Send article text to the NL API's classifyText method

def classify_text(article):
    response = nl_client.classify_text(
        document=language.Document(
            content=article,
            type=language.Document.Type.PLAIN_TEXT
        )
    )
    return response

rows_for_bq = []
files = storage_client.bucket('qwiklabs-test-bucket-gsp063').list_blobs()
print("Got article files from GCS, sending them to the NL API (this will take ~2 minutes)...")
print(f"example file {files[0]}")

# Send files to the NL API and save the result to send to BigQuery

for file in files:
    if file.name.endswith('txt'):
        article_text = file.download_as_bytes().decode('utf-8')  # Decode bytes to string
        nl_response = classify_text(article_text)
        if len(nl_response.categories) > 0:
            rows_for_bq.append((article_text, nl_response.categories[0].name, nl_response.categories[0].confidence))

print("Writing NL API article data to BigQuery...")

# Write article text + category data to BQ

if rows_for_bq:
    errors = bq_client.insert_rows(table, rows_for_bq)
    if errors:
        print("Encountered errors while writing to BigQuery:", errors)
else:
    print("No articles found in the specified bucket.")

```
3. Analyze data
```
SELECT * FROM `Project ID.news_classification_dataset.article_data`


SELECT
  category,
  COUNT(*) c
FROM
  `Project ID.news_classification_dataset.article_data`
GROUP BY
  category
ORDER BY
  c DESC


SELECT * FROM `Project ID.news_classification_dataset.article_data`
WHERE category = "/Arts & Entertainment/Music & Audio/Classical Music"


SELECT
  article_text,
  category
FROM `Project ID.news_classification_dataset.article_data`
WHERE cast(confidence as float64) > 0.9
```