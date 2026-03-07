1. Setup
```
gcloud config set compute/zone "ZONE"
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gcloud container clusters create gmp-cluster --num-nodes=1 --zone "ZONE"


# For log alert
resource.type="gce_instance" protoPayload.methodName="v1.compute.instances.stop"


# Docker
gcloud artifacts repositories create docker-repo --repository-format=docker \
    --location=Region --description="Docker repository" \
    --project=Project ID


 wget https://storage.googleapis.com/spls/gsp1024/flask_telemetry.zip
 unzip flask_telemetry.zip
 docker load -i flask_telemetry.tar
```