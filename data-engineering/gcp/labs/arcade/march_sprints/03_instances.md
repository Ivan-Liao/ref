1. Setup
```
LOCATION_ZONE=YOUR_ZONE -- europe-west4-b
gcloud config set compute/zone $YOUR_ZONE


gcloud storage buckets create gs://qwiklabs-gcp-00-fa63702102e0-bucket --project=$(gcloud config get-value project) --default-storage-class=standard --uniform-bucket-level-access --public-access-prevention
gsutil cp -r gs://spls/gsp087/* gs://qwiklabs-gcp-00-fa63702102e0-bucket


Startup.sh - A shell script that installs the necessary components to each Compute Engine instance as the instance is added to the managed instance group.
writeToCustomMetric.js - A Node.js snippet that creates a custom monitoring metric whose value triggers scaling. In a production environment, this would be your actual application code, and the value it reports (appdemo_queue_depth_01) would be a critical business metric, such as: the number of pending messages in a queue, the number of open database connections, or the length of a batch processing backlog.
Config.json - A Node.js config file that specifies the values for the custom monitoring metric and used in writeToCustomMetric.js.
Package.json - A Node.js package file that specifies standard installation and dependencies for writeToCustomMetric.js.
writeToCustomMetric.sh - A shell script that continuously runs the writeToCustomMetric.js program on each Compute Engine instance.
```
2. Instance setup
   1. Templating
   2. Group creation
   3. Configure autoscaling
3. Autoscaling example