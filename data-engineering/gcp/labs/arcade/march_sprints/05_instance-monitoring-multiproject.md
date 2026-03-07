1. Setup
```
gcloud compute instances create lamp-1-vm \
    --zone=<ZONE> \
    --machine-type=e2-medium \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --tags=http-server
```
2. Create cloud monitoring group
3. Create uptime check
4. Add alert policy
5. Create dashboard