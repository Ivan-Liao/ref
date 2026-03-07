- [AI](#ai)
- [Artifact Registry](#artifact-registry)
- [Bigquery](#bigquery)
- [Compute](#compute)
- [GCS](#gcs)
- [IAM](#iam)
- [KMS](#kms)
- [Kubernetes](#kubernetes)
- [Monitoring](#monitoring)
- [Networking](#networking)

# AI
1. gcloud ml
```
gcloud ml language analyze-entities --content="Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'." > result.json
# The entity name and type, a person, location, event, etc...metadata, an associated Wikipedia URL if there is one... salience, and the indices of where this entity appeared in the text. Salience is a number in the [0,1] range that refers to the centrality of the entity to the text as a whole... mentions, which is the same entity mentioned in different ways.
```
# Artifact Registry
```
gcloud auth configure-docker us-central1-docker.pkg.dev
gcloud artifacts repositories create my-repository --repository-format=docker --location=us-central1 --description="Docker repository"
# Build to the AR repo
docker build -t us-central1-docker.pkg.dev/qwiklabs-gcp-04-aca6299d4f5b/my-repository/node-app:0.2 .
docker push us-central1-docker.pkg.dev/qwiklabs-gcp-04-aca6299d4f5b/my-repository/node-app:0.2
```

# Bigquery
1. Object management
```
# create dataset
bq mk YOUR_DATASET_NAME


# create table
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,\
point_idx:integer,\
latitude:float,\
timestamp:timestamp,\
 -t YOUR_DATASET_NAME.YOUR_TABLE_NAME

# example
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,\
point_idx:integer,\
latitude:float,\
longitude:float,\
timestamp:timestamp,\
meter_reading:float,\
meter_increment:float,\
ride_status:string,\
passenger_count:integer\
 -t YOUR_DATASET_NAME.YOUR_TABLE_NAME
```

# Compute
1. Creating an instance
```
INSTANCE_NAME=YOUR_INSTANCE_NAME
LOCATION_ZONE = YOUR_LOCATION_ZONE
MACHINE_TYPE=YOUR_MACHINE_TYPE
SUBNET_NAME=YOUR_SUBNET_NAME
IMAGE_FAMILY=YOUR_IMAGE_FAMILY
IMAGE_PROJECT=YOUR_IMAGE_PROJECT
BOOT_DISK_SIZE=YOUR_BOOT_DISK_SIZE
BOOT_DISK_TYPE=YOUR_BOOT_DISK_TYPE
BOOT_DISK_DEVICE_NAME=YOUR_BOOK_DIST_DEVICE_NAME
gcloud compute instances create $INSTANCE_NAME --zone $LOCATION_ZONE \
    --machine-type $MACHINE_TYPE \
    --subnet $SUBNET_NAME \
    --image-family $IMAGE_FAMILY \
    --image-project $IMAGE_PROJECT \
    --boot-disk-size $BOOT_DISK_SIZE \
    --boot-disk-type $BOOT_DISK_TYPE \
    --boot-disk-device-name $BOOT_DISK_DEVICE_NAME


gcloud compute instances create lamp-1-vm \
    --zone=<ZONE> \
    --machine-type=e2-medium \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --tags=http-server
```
2. Instance Management
```
# ssh into instance
gcloud compute ssh YOUR_INSTANCE_NAME
```


# GCS
   1. Create bucket
```
# GCS
EXPORT REGION = YOUR_REGION
gcloud storage buckets create gs://qwiklabs-gcp-01-83c4633b6cba-bucket --location=$REGION 
# with uniform bucket access (no acl) and default storage specified and public access prevention 
gcloud storage buckets create gs://qwiklabs-gcp-01-83c4633b6cba-bucket --location=$REGION --project=$(gcloud config get-value project) --default-storage-class=standard --uniform-bucket-level-access --public-access-prevention
```
   2. Manipulate objects
```
# create folders
echo "" | gcloud storage cp - gs://YOUR_FOLDER_PATH/ # echo "" creates an empty file, make sure there is a trailing slash in YOUR_FOLDER_PATH


# delete files
gcloud storage rm gs://YOUR-BUCKET-NAME/ada.jpg
# delete folder 
gcloud storage rm --recursive gs://YOUR_FOLDER_PATH/


# upload file
gcloud storage cp ./YOUR_FILE_PATH gs://YOUR_FOLDER_PATH/
# entire folder
gcloud storage cp -r ./my-local-folder gs://YOUR_FOLDER_PATH/
# multiple files
gcloud storage cp file1.txt file2.jpg gs://YOUR_FOLDER_PATH/
# wildcards
gcloud storage cp ./logs/*.log gs://YOUR_LOG_FOLDER_PATH/
# parallel upload (n flag noclover for skipping duplicates)
gcloud storage cp -n ./large-folder gs://YOUR_FOLDER_PATH/


# list bucket objects
gcloud storage ls gs://YOUR_BUCKET_NAME/
```

# IAM
1. Permissions
```
# list permissions
gcloud projects get-iam-policy YOUR_PROJECT_ID --filter="bindings.members:<YOUR_USER_ID>"
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:my-account@$PROJECT.iam.gserviceaccount.com --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:my-account@$PROJECT.iam.gserviceaccount.com --role=roles/serviceusage.serviceUsageConsumer

# Project level
gcloud projects remove-iam-policy-binding PROJECT_ID \
    --member="user:YOUR_USER_ID" \
    --role="roles/editor"


# Bucket level
gcloud storage buckets add-iam-policy-binding gs://BUCKET_NAME \
    --member="allUsers" \
    --role="roles/storage.objectViewer"


# Might not be possible objects with roles, use acls instead
<!-- # Object level
https://storage.googleapis.com/BUCKET_NAME/OBJECT_NAME
gcloud storage objects add-iam-policy-binding gs://YOUR_OBJECT_PATH \
    --member="allUsers" \
    --role="roles/storage.objectViewer"
## to disable uniform level access
gcloud storage buckets update gs://my_bucket --no-uniform-bucket-level-access -->


# ACL
gcloud storage objects update gs://YOUR-BUCKET-NAME/ada.jpg --add-acl-grant=entity=allUsers,role=READER
gcloud storage objects update gs://YOUR-BUCKET-NAME/ada.jpg --remove-acl-grant=allUsers
https://storage.googleapis.com/YOUR_FILE_PATH
https://storage.googleapis.com/qwiklabs-gcp-02-33632c6dfabb-bucket/kitten.png
```
2. Services
   1. service list
      1. appengine.googleapis.com
      2. vision.googleapis.com
      3. cloudkms.googleapis.com
```
# enable or disable services
gcloud services enable appengine.googleapis.com
gcloud services disable appengine.googleapis.com

# list of common services
gcloud services list

# api key management key only, can be easiest to have access to all apis by default
gcloud services api-keys create --display-name="Vision-API-Key"
gcloud services api-keys list
gcloud services api-keys update [KEY_ID] \
    --api-target=service=vision.googleapis.com
# restrict api usage for better practice


# api key management with service account best practice
gcloud iam service-accounts create vision-sa \
    --description="Service account for Vision API" \
    --display-name="Vision Service Account"
# Get your Project ID
PROJECT_ID=$(gcloud config get-value project)
# Grant the 'Vision AI Viewer' role to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:vision-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/visionai.viewer"
gcloud iam service-accounts keys create ./vision-key.json \
    --iam-account=vision-sa@$PROJECT_ID.iam.gserviceaccount.com
```

3. Authentication
```
# browser login
gcloud auth login
# long url provided to receive auth code for terminal
gcloud auth login --no-launch-browser
# service account
gcloud auth activate-service-account --key-file=KEY_FILE.json
# check active account and project and set region
gcloud auth list
gcloud config set account YOUR_ACCOUNT
gcloud config list project
gcloud config set compute/region europe-west1
gcloud config list # show all config commands
```


# KMS
```
gcloud kms keyrings create $KEYRING_NAME --location global
gcloud kms keys create $CRYPTOKEY_NAME --location global \
      --keyring $KEYRING_NAME \
      --purpose encryption
```


# Kubernetes
```
gcloud container clusters create bootcamp \
  --machine-type e2-small \
  --num-nodes 3 \
  --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

kubectl explain deployment
kubectl explain deployment --recursive
kubectl explain deployment.metadata.name


# create deployment
kubectl create -f deployments/fortune-app-blue.yaml
# verify deployment
kubectl get deployments
kubectl get replicasets
kubectl get pods
kubectl get services fortune-app
curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
# scaling
kubectl scale deployment fortune-app-blue --replicas=5
kubectl get pods | grep fortune-app-blue | wc -lA
# rollout automatic after file is edited
kubectl edit deployment fortune-app-blue
kubectl rollout pause deployment/fortune-app-blue
kubectl rollout status deployment/fortune-app-blue
kubectl rollout undo deployment/fortune-app-blue
```

# Monitoring
1. Cloud Monitoring lets you define and monitor groups of resources, such as VM instances, databases, and load balancers. Groups can be based on names, tags, regions, applications, and other criteria. You can also create subgroups, up to six levels deep, within groups
   1. Uptime checks
      1. Frequency
   2. Alerts
      1. Network traffic threshold MB/sec
   3. Dashboards
2. Cloud overview audit logs


# Networking
1. VPNs see labs\arcade\march_holistic\12_vpn.md