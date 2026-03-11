1. Setup
```
gcloud compute instances create lamp-1-vm \
    --zone=<ZONE> \
    --machine-type=e2-medium \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --tags=http-server


gcloud compute instances create instance2 \
--project=qwiklabs-gcp-00-cb57c3e41863 \
--zone=europe-west4-b \
--machine-type=e2-medium \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
--metadata=enable-osconfig=TRUE \
--maintenance-policy=MIGRATE \
--provisioning-model=STANDARD \
--service-account=466833554589-compute@developer.gserviceaccount.com \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=instance2,image=projects/debian-cloud/global/images/debian-12-bookworm-v20260210,mode=rw,size=10,type=pd-balanced \
--no-shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--labels=goog-ops-agent-policy=v2-template-1-5-0,goog-ec-src=vm_add-gcloud \
--reservation-affinity=any

printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-template-1-5-0\n' > config.yaml 


gcloud compute instances ops-agents policies create goog-ops-agent-v2-template-1-5-0-europe-west4-b --project=qwiklabs-gcp-00-cb57c3e41863 \
--zone=europe-west4-b \
--file=config.yaml 


gcloud compute resource-policies create snapshot-schedule default-schedule-1 \
--project=qwiklabs-gcp-00-cb57c3e41863 \
--region=europe-west4 \
--max-retention-days=14 \
--on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=20:00 


gcloud compute disks add-resource-policies instance2 \
--project=qwiklabs-gcp-00-cb57c3e41863 \
--zone=europe-west4-b \
--resource-policies=projects/qwiklabs-gcp-00-cb57c3e41863/regions/europe-west4/resourcePolicies/default-schedule-1
```
2. Create cloud monitoring group
3. Create uptime check
4. Add alert policy
5. Create dashboard