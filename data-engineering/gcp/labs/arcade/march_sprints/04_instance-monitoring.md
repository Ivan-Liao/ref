1. Setup
```
gcloud compute instances create lamp-1-vm \
    --zone=<ZONE> \
    --machine-type=e2-medium \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --tags=http-server


sudo apt-get update
sudo apt-get install apache2 php7.0
sudo service apache2 restart


curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo systemctl status google-cloud-ops-agent"*"
```