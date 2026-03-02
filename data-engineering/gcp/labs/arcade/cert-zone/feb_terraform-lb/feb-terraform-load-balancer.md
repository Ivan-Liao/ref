1. Setup
```
gcloud services enable cloudaicompanion.googleapis.com

git clone https://github.com/terraform-google-modules/terraform-google-lb-http.git
cd ~/terraform-google-lb-http/examples/multi-backend-multi-mig-bucket-https-lb

```
2. Use Gemini Code Assist to alter file
```
In the main.tf configuration file, update the "gce-lb-https" module. Add the following arguments without altering other values:

* create_ssl_certificate = true
* managed_ssl_certificate_domains = ["example.com"]
```

3. Run terraform
```
terraform init
terraform plan -out=tfplan -var 'project=qwiklabs-gcp-00-58f23e34a388'
```

4. Edit load balancer
```
EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)

echo https://${EXTERNAL_IP}
echo https://${EXTERNAL_IP}/group1
echo https://${EXTERNAL_IP}/group2
echo https://${EXTERNAL_IP}/group3
```