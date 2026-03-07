1. Setup
```
gcloud services enable vision.googleapis.com
gcloud services api-keys create --display-name="Vision-API-Key"
gcloud services api-keys list
gcloud services api-keys update [KEY_ID] \
    --api-target=service=vision.googleapis.com


gcloud storage buckets create gs://qwiklabs-gcp-03-8fc5d01142ba-bucket
gcloud storage objects update gs://qwiklabs-gcp-03-8fc5d01142ba-bucket/sign.jpg --add-acl-grant=entity=allUsers,role=READER

# create json request file
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "gs://qwiklabs-gcp-03-8fc5d01142ba-bucket/sign.jpg"
          }
        },
        "features": [
          {
            "type": "TEXT_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
```
2. Call Vision API for OCR
```
curl -s -X POST -H "Content-Type: application/json" --data-binary @ocr-request.json  https://vision.googleapis.com/v1/images:annotate?key=${API_KEY} -o ocr-response.json

```
3. Call Translation API
```
{
  "q": "your_text_here",
  "target": "en"
}


STR=$(jq .responses[0].textAnnotations[0].description ocr-response.json) && STR="${STR//\"}" && sed -i "s|your_text_here|$STR|g" translation-request.json
curl -s -X POST -H "Content-Type: application/json" --data-binary @translation-request.json https://translation.googleapis.com/language/translate/v2?key=${API_KEY} -o translation-response.json
cat translation-response.json
```
4. Call NLP API for analysis
```
{
  "document":{
    "type":"PLAIN_TEXT",
    "content":"your_text_here"
  },
  "encodingType":"UTF8"
}

STR=$(jq .data.translations[0].translatedText  translation-response.json) && STR="${STR//\"}" && sed -i "s|your_text_here|$STR|g" nl-request.json
curl "https://language.googleapis.com/v1/documents:analyzeEntities?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @nl-request.json
```