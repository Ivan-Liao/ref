# Import Python libraries
import vertexai
from vertexai.generative_models import GenerativeModel, Part
from google.cloud import bigquery
from google.cloud import storage
import json
import io
import matplotlib.pyplot as plt
from IPython.display import HTML, display
from IPython.display import Audio
from pprint import pprint


import os
PROJECT_ID = "qwiklabs-gcp-00-ca5167bab5df"
LOCATION = os.environ.get("GOOGLE_CLOUD_REGION", "global")

'''
# magic inline commands
# Create the resource connection
!bq mk --connection \
  --connection_type=CLOUD_RESOURCE \
  --location=US \
  gemini_conn


# Create the dataset
%%bigquery
CREATE SCHEMA IF NOT EXISTS `qwiklabs-gcp-00-ca5167bab5df.gemini_demo`
OPTIONS(location="US");


# Create the customer reviews table
%%bigquery
LOAD DATA OVERWRITE gemini_demo.customer_reviews
(customer_review_id INT64, customer_id INT64, location_id INT64, review_datetime DATETIME, review_text STRING, social_media_source STRING, social_media_handle STRING)
FROM FILES (
  format = 'CSV',
  uris = ['gs://qwiklabs-gcp-00-ca5167bab5df-bucket/gsp1249/customer_reviews.csv']);


# Create the customer reviews table
%%bigquery
SELECT * FROM `gemini_demo.customer_reviews`
ORDER BY review_datetime


# Create the customer reviews table
%%bigquery
CREATE OR REPLACE MODEL `gemini_demo.gemini_flash`
REMOTE WITH CONNECTION `us.gemini_conn`
OPTIONS (endpoint = 'gemini-2.5-flash')


# Create the sentiment analysis table
%%bigquery
CREATE OR REPLACE TABLE
`gemini_demo.customer_reviews_analysis` AS (
SELECT ml_generate_text_llm_result, social_media_source, review_text, customer_id, location_id, review_datetime
FROM
ML.GENERATE_TEXT(
MODEL `gemini_demo.gemini_flash`,
(
   SELECT social_media_source, customer_id, location_id, review_text, review_datetime, CONCAT(
      'Classify the sentiment of the following text as positive or negative.',
      review_text, "In your response don't include the sentiment explanation. Remove all extraneous information from your response, it should be a boolean response either positive or negative.") AS prompt
   FROM `gemini_demo.customer_reviews`
),
STRUCT(
   0.2 AS temperature, TRUE AS flatten_json_output)));


# Pull the first 50 records from the customer_reviews_analysis table
%%bigquery
SELECT * FROM `gemini_demo.customer_reviews_analysis`
ORDER BY review_datetime


# Sanitize the records within a new view
%%bigquery
CREATE OR REPLACE VIEW gemini_demo.cleaned_data_view AS
SELECT REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', '') AS sentiment,
REGEXP_REPLACE(
      REGEXP_REPLACE(
            REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'),
            'YELP', 'Yelp'
      ),
      r'SocialMedia1?', 'Social Media'
   ) AS social_media_source,
review_text, customer_id, location_id, review_datetime
FROM `gemini_demo.customer_reviews_analysis`;
'''

# Task 6.5 - Create the BigQuery client, and query the cleaned data view for positive and negative reviews, store the results in a dataframe and then show the first 10 records
client = bigquery.Client()
query = "SELECT sentiment, COUNT(*) AS count FROM `gemini_demo.cleaned_data_view` WHERE sentiment like 'negative%' OR sentiment like 'positive%' GROUP BY sentiment;"
query_job = client.query(query)
results = query_job.result().to_dataframe()
results.head(10)


# Task 6.7 - Build the report.
plt.bar(sentiment, count, color='skyblue')
plt.xlabel("Sentiment")
plt.ylabel("Total Count")
plt.title("Bar Chart from BigQuery Data")
plt.show()



# 7 Conduct sentiment analysis on audio files and respond to the customer.
vertexai.init(project="qwiklabs-gcp-00-ca5167bab5df", location="us-west4")

model = GenerativeModel(model_name="gemini-2.5-flash")

prompt = """
Please provide a transcript for the audio.
Then provide a summary for the audio.
Then identify the keywords in the transcript.
Be concise and short.
Do not make up any information that is not part of the audio and do not be verbose.
Then determine the sentiment of the audio: positive, neutral or negative.

Also, you are a customer service representative.
How would you respond to this customer review?
From the customer reviews provide actions that the location can take to improve. The response and the actions should be simple, and to the point. Do not include any extraneous characters in your response.
Answer in JSON format with five keys: transcript, summary, keywords, sentiment, response and actions. Transcript should be a string, summary should be a sting, keywords should be a list, sentiment should be a string, customer response should be a string and actions should be string.
"""

bucket_name = "qwiklabs-gcp-00-ca5167bab5df-bucket"
folder_name = 'gsp1249/audio'  # Include the trailing '/'

def list_mp3_files(bucket_name, folder_name):
   storage_client = storage.Client()
   bucket = storage_client.bucket(bucket_name)
   print('Accessing ', bucket, ' with ', storage_client)

   blobs = bucket.list_blobs(prefix=folder_name)

   mp3_files = []
   for blob in blobs:
      if blob.name.endswith('.mp3'):
            mp3_files.append(blob.name)
   return mp3_files

file_names = list_mp3_files(bucket_name, folder_name)
if file_names:
   print("MP3 files found:")
   print(file_names)
   for file_name in file_names:
      audio_file_uri = f"gs://{bucket_name}/{file_name}"
      print('Processing file at ', audio_file_uri)
      audio_file = Part.from_uri(audio_file_uri, mime_type="audio/mpeg")
      contents = [audio_file, prompt]
      response = model.generate_content(contents)
      print(response.text)
else:
   print("No MP3 files found in the specified folder.")


# Generate the transcript for the negative review audio file, create the JSON object, and associated variables

audio_file_uri = f"gs://{bucket_name}/{folder_name}/data-beans_review_7061.mp3"
print(audio_file_uri)

audio_file = Part.from_uri(audio_file_uri, mime_type="audio/mpeg")

contents = [audio_file, prompt]

response = model.generate_content(contents)
print('Generating Transcript...')
#print(response.text)

results = response.text
# print("your results are", results, type(results))
print('Transcript created...')

print('Transcript ready for analysis...')

json_data = results.replace('```json', '')
json_data = json_data.replace('```', '')
jason_data = '"""' + results + '"""'

# print(json_data, type(json_data))

data = json.loads(json_data)

# print(data)

transcript = data["transcript"]
summary = data["summary"]
sentiment = data["sentiment"]
keywords = data["keywords"]
response = data["response"]
actions = data["actions"]


# Create an HTML table (including the image) from the selected values.

html_string = f"""
<table style="border-collapse:collapse;width:100%;padding:10px;">
<tbody><tr style="background-color:#f2f2f2;">
<th style="padding:10px;width:50%;text-align:left;">customer_id: 7061 - @coffee_lover789</th>
<th style="padding:10px;width:50%;text-align:left;">&nbsp;</th>
</tr></tbody>
</table>
<table>
<tbody>
<tr style="padding:10px;">
<td style="padding:10px;">{transcript}</td>
<td style="padding:10px;color:red;">{sentiment} feedback</td>
</tr>
<tr>
</tr>
<tr style="padding:10px;">
<td style="padding:10px;">&nbsp;</td>
<td style="padding:10px;">
<table>
<tbody>
<tr><td>{keywords[0]}</td></tr>
<tr><td>{keywords[1]}</td></tr>
<tr><td>{keywords[2]}</td></tr>
<tr><td>{keywords[3]}</td></tr>
</tbody>
</table>
</td>
</tr>
<tr style="padding:10px;">
<td style="padding:10px;">
<strong>Customer summary:</strong>{summary}</td>
</tr>
<tr style="padding:10px;">
<td style="padding:10px;">
<strong>Recommended actions:</strong>{actions}</td>
</tr>
<tr style="padding:10px;">
<td style="padding:10px;background-color:#EAE0CF;">
<strong>Suggested Response:</strong>{response}</td>
</tr>
</tbody>
</table>

"""
print('The table has been created.')


# Download the audio file from Google Cloud Storage and load into the player
storage_client = storage.Client()
bucket = storage_client.bucket(bucket_name)
blob = bucket.blob(f"{folder_name}/data-beans_review_7061.mp3")
audio_bytes = io.BytesIO(blob.download_as_bytes())

# Assuming a sample rate of 44100 Hz (common for MP3 files)
sample_rate = 44100

print('The audio file is loaded in the player.')