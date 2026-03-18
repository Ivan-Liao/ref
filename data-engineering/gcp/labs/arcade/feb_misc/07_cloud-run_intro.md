1. Enable APIs
```
export PROJECT_ID=$(gcloud config get-value project)
export REGION=europe-west4
gcloud config set compute/region $REGION
gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com
```
2. Set required permissions
```
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
    --role="roles/eventarc.eventReceiver"

SERVICE_ACCOUNT="$(gcloud storage service-agent --project=$PROJECT_ID)"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role='roles/pubsub.publisher'
```

3. Create the function
```
nano index.js

/**
* index.js Cloud Function - Avro on GCS to BQ
*/
const {Storage} = require('@google-cloud/storage');
const {BigQuery} = require('@google-cloud/bigquery');

const storage = new Storage();
const bigquery = new BigQuery();

exports.loadBigQueryFromAvro = async (event, context) => {
    try {
        // Check for valid event data and extract bucket name
        if (!event || !event.bucket) {
            throw new Error('Invalid event data. Missing bucket information.');
        }

        const bucketName = event.bucket;
        const fileName = event.name;

        // BigQuery configuration
        const datasetId = 'loadavro';
        const tableId = fileName.replace('.avro', ''); 

        const options = {
            sourceFormat: 'AVRO',
            autodetect: true, 
            createDisposition: 'CREATE_IF_NEEDED',
            writeDisposition: 'WRITE_TRUNCATE',     
        };

        // Load job configuration
        const loadJob = bigquery
            .dataset(datasetId)
            .table(tableId)
            .load(storage.bucket(bucketName).file(fileName), options);

        await loadJob;
        console.log(`Job ${loadJob.id} completed. Created table ${tableId}.`);

    } catch (error) {
        console.error('Error loading data into BigQuery:', error);
        throw error; 
    }
};
```
  1. ctrl + x >> y > enter
4. Create a cloud storage bucket and bq dataset
```
gcloud storage buckets create gs://$PROJECT_ID --location=$REGION

bq mk -d  loadavro
```

5. Deploy function
```
npm install @google-cloud/storage @google-cloud/bigquery

gcloud functions deploy loadBigQueryFromAvro \
    --gen2 \
    --runtime nodejs20 \
    --source . \
    --region $REGION \
    --trigger-resource gs://$PROJECT_ID \
    --trigger-event google.storage.object.finalize \
    --memory=512Mi \
    --timeout=540s \
    --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com 


# confirm event trigger creation
gcloud eventarc triggers list --location=$REGION

# download avro file
wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro

# move avro file to staging cloud storage 
gcloud storage cp campaigns.avro gs://qwiklabs-gcp-00-d1864c1fc529
```

6. Confirm data was loaded into bq
```
bq query \
 --use_legacy_sql=false \
 'SELECT * FROM `loadavro.campaigns`;'
```

7. View logs
```
gcloud logging read "resource.labels.service_name=loadBigQueryFromAvro"
```