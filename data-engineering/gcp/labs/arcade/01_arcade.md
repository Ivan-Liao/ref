1. GCP bucket to private

```
gcloud storage buckets update gs://qwiklabs-gcp-02-36fa00a26f84-urgent --public-access-prevention

# --no-public-access-prevention to reverse
```

2.  CORS confiuration
```
# for json file config
{
  "cors": [
    {
      "origin": ["http://example.com"],
      "method": ["GET"],
      "responseHeader": ["Content-Type"],
      "maxAgeSeconds": 3600
    }
  ]
}

# for CLI
[
  {
    "origin": ["http://example.com"],
    "method": ["GET"],
    "responseHeader": ["Content-Type"],
    "maxAgeSeconds": 3600
  }
]

# syntax
gcloud storage buckets update gs://BUCKET_NAME --cors-file=CORS_CONFIG_FILE
# example
gcloud storage buckets update gs://qwiklabs-gcp-04-c617e24f701c-bucket/ --cors-file=cors_config.json
# clear cors config
gcloud storage buckets update gs://BUCKET_NAME --clear-cors

```

3. Set up CDN with GCS backend
```
gcloud storage buckets add-iam-policy-binding gs://BUCKET_NAME --member=allUsers --role=roles/storage.objectViewer
gcloud storage buckets add-iam-policy-binding gs://qwiklabs-gcp-02-c839b5307bfb-bucket --member=allUsers --role=roles/storage.objectViewer

gcloud compute backend-buckets create cat-backend-bucket \
    --gcs-bucket-name=BUCKET_NAME \
    --enable-cdn \
    --cache-mode=CACHE_ALL_STATIC
gcloud compute backend-buckets create cat-backend-bucket --gcs-bucket-name=qwiklabs-gcp-02-c839b5307bfb-bucket --enable-cdn --cache-mode=CACHE_ALL_STATIC

gsutil ls gs://qwiklabs-gcp-02-c839b5307bfb-bucket/images
gs://qwiklabs-gcp-02-c839b5307bfb-bucket/images/kitten.png

# create url map
gcloud compute url-maps create http-lb --default-backend-bucket=cat-backend-bucket
# create target proxy
gcloud compute target-http-proxies create http-lb-proxy --url-map=http-lb
# create forwarding rule
gcloud compute forwarding-rules create http-lb-forwarding-rule --load-balancing-scheme=EXTERNAL_MANAGED --network-tier=PREMIUM  --global --target-http-proxy=http-lb-proxy --ports=80
# --address=example-ip for reserved ip
gcloud compute forwarding-rules list --global

gcloud compute addresses describe 34.49.28.126 --format="get(address)" --global
curl http://IP_ADDRESS/images/kitten.png
curl -D- -o /dev/null http://34.49.28.126/images/kitten.png

gcloud storage cp gs://qwiklabs-gcp-02-c839b5307bfb-bucket/images/kitten.png ~
```