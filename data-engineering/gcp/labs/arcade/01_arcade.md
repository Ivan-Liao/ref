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
gcloud storage buckets add-iam-policy-binding gs://qwiklabs-gcp-04-8dbad76244a7-bucket --member=allUsers --role=roles/storage.objectViewer
# remove-iam-policy-binding to reverse

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
curl -D- -o /dev/null http://34.160.99.226/index.html

gcloud storage cp gs://qwiklabs-gcp-02-c839b5307bfb-bucket/images/kitten.png ~
```

1. Set up a static website 
```
gcloud storage buckets update gs://qwiklabs-gcp-01-8febaee5369a-bucket --web-main-page-suffix=index.html --web-error-page=error.html

gcloud storage buckets update gs://qwiklabs-gcp-01-8febaee5369a-bucket --no-uniform-bucket-level-access
gcloud storage objects update gs://qwiklabs-gcp-01-8febaee5369a-bucket/index.html --add-acl-grant=entity=allUsers,role=OWNER
gcloud storage objects update gs://qwiklabs-gcp-01-8febaee5369a-bucket/error.html --add-acl-grant=entity=allUsers,role=OWNER
```

5. Set up a gcs lifecycle policy
```
gcloud storage buckets update gs://qwiklabs-gcp-04-6c7c735452e2-bucket --lifecycle-file=lifecycle_policy.json

{
  "lifecycle": {
    "rule": [
      {
        "action": { "type": "SetStorageClass", "storageClass": "NEARLINE" },
        "condition": {
          "age": 30,
          "matchesPrefix": ["projects/active/"]
        }
      },
      {
        "action": { "type": "SetStorageClass", "storageClass": "NEARLINE" },
        "condition": {
          "age": 90,
          "matchesPrefix": ["archive/"]
        }
      },
      {
        "action": { "type": "SetStorageClass", "storageClass": "COLDLINE" },
        "condition": {
          "age": 180,
          "matchesPrefix": ["archive/"]
        }
      },
      {
        "action": { "type": "Delete" },
        "condition": {
          "age": 7,
          "matchesPrefix": ["processing/temp_logs/"]
        }
      }
    ]
  }
}
```

6. Create bucket load balancer with fault tolerance
```
gcloud storage buckets create gs://qwiklabs-gcp-02-e179340e3dc8-new --project=qwiklabs-gcp-02-e179340e3dc8 --default-storage-class=standard --location=asia-southeast1 --uniform-bucket-level-access

gcloud storage cp -r gs://qwiklabs-gcp-02-e179340e3dc8-bucket gs://qwiklabs-gcp-02-e179340e3dc8-new

gcloud storage buckets add-iam-policy-binding gs://qwiklabs-gcp-02-e179340e3dc8-bucket --member=allUsers --role=roles/storage.objectViewer
gcloud storage buckets add-iam-policy-binding gs://qwiklabs-gcp-02-e179340e3dc8-new --member=allUsers --role=roles/storage.objectViewer

# create backend buckets
gcloud compute backend-buckets create backend-bucket-1 --gcs-bucket-name=qwiklabs-gcp-02-e179340e3dc8-bucket
gcloud compute backend-buckets create backend-bucket-2 --gcs-bucket-name=qwiklabs-gcp-02-e179340e3dc8-new
# create url map
gcloud compute url-maps create http-lb --default-backend-bucket=backend-bucket-1
# Example: Send all traffic to error.html to backend-bucket-2
gcloud compute url-maps add-path-matcher http-lb --path-matcher-name=path-matcher-2 --new-hosts=* --backend-bucket-path-rules="/error.html=backend-bucket-2" --default-backend-bucket=backend-bucket-1
# create target proxy
gcloud compute target-http-proxies create http-lb-proxy --url-map=http-lb
# create forwarding rule
gcloud compute forwarding-rules create http-lb-forwarding-rule --load-balancing-scheme=EXTERNAL_MANAGED --network-tier=PREMIUM  --global --target-http-proxy=http-lb-proxy --ports=80
# --address=example-ip for reserved ip
gcloud compute forwarding-rules list --global

curl http://136.110.143.90/index.html
```