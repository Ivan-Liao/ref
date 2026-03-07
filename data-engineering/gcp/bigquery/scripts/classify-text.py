
from google.cloud import storage, language, bigquery

# Set up your GCS, NL, and BigQuery clients

storage_client = storage.Client()
nl_client = language.LanguageServiceClient()
bq_client = bigquery.Client(project='qwiklabs-gcp-01-8d1095d6d005')

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

