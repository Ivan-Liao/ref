1. GCS
   1. Create bucket
```
# GCS
EXPORT REGION = YOUR_REGION
gcloud storage buckets create gs://qwiklabs-gcp-01-83c4633b6cba-bucket --location=$REGION 
# with uniform bucket access (no acl) and default storage specified and public access prevention 
gcloud storage buckets create gs://qwiklabs-gcp-01-83c4633b6cba-bucket --location=$REGION --project=$(gcloud config get-value project) --default-storage-class=standard --uniform-bucket-level-access --public-access-prevention
```
2. Permissions
```
# list permissions
gcloud projects get-iam-policy YOUR_PROJECT_ID --filter="bindings.members:<YOUR_USER_ID>"

# Account level
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
3. Manipulate bucket objects
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
4. Authentication
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

```

100.   Misc
```
# enable or disable services
gcloud services enable appengine.googleapis.com
gcloud services disable appengine.googleapis.com
```