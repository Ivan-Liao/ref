1. Initial config
```
gcloud config set compute/region us-east5
```

2. Types of service account
   1. Compute Engine
      1. PROJECT_NUMBER-compute@developer.gserviceaccount.com
   2. App Engine
      1. PROJECT_ID@appspot.gserviceaccount.com
   3. Google managed
      1. PROJECT_NUMBER@cloudservices.gserviceaccount.com (API service account)
   4. Roles
      1. Primitive (Owner, Editor, Viewer)
      2. Predefined (granular access managed by GCP)
      3. Custom (granular access)
   5. Service account can be treated as an identity or a resource

3. Create and grant roles to service accounts
```
gcloud iam service-accounts create my-sa-123 --display-name "my service account"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:my-sa-123@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/editor
```

4. Create service account for BQ
   1. Create service account
   2. Create VM instance linked to service account
      1. Access scope (set access for each API) >> enable BQ
   3. SSH into VM
```
# Install python and create venv
sudo apt-get update
sudo apt install python3 python3-pip python3.11-venv -y
python3 -m venv myvenv
source myvenv/bin/activate

sudo apt-get update
sudo apt-get install -y git python3-pip
pip3 install --upgrade pip
pip3 install google-cloud-bigquery pyarrow pandas db-dtypes
```
   1. Create python file and run
```
echo "
from google.auth import compute_engine
from google.cloud import bigquery

credentials = compute_engine.Credentials(
    service_account_email='YOUR_SERVICE_ACCOUNT')

query = '''
SELECT
  year,
  COUNT(1) as num_babies
FROM
  publicdata.samples.natality
WHERE
  year > 2000
GROUP BY
  year
'''

client = bigquery.Client(
    project='qwiklabs-gcp-01-5bb0cb41a1ab',
    credentials=credentials)
print(client.query(query).to_dataframe())
" > query.py

sed -i -e "s/qwiklabs-gcp-01-5bb0cb41a1ab/$(gcloud config get-value project)/g" query.py
cat query.py
sed -i -e "s/YOUR_SERVICE_ACCOUNT/bigquery-qwiklab@$(gcloud config get-value project).iam.gserviceaccount.com/g" query.py
cat query.py
python3 query.py
```
