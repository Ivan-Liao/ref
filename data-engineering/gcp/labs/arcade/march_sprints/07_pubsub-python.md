1. Setup
```
sudo apt-get install -y virtualenv
python3 -m venv venv
source venv/bin/activate


pip install --upgrade google-cloud-pubsub
git clone https://github.com/googleapis/python-pubsub.git
cd python-pubsub/samples/snippets


echo $GOOGLE_CLOUD_PROJECT
cat publisher.py
python publisher.py -h
```
2. Run programs
```
python publisher.py $GOOGLE_CLOUD_PROJECT create MyTopic
python publisher.py $GOOGLE_CLOUD_PROJECT list
python subscriber.py $GOOGLE_CLOUD_PROJECT create MyTopic MySub
python subscriber.py $GOOGLE_CLOUD_PROJECT list-in-project
python subscriber.py -h
gcloud pubsub topics publish MyTopic --message "Hello"
gcloud pubsub topics publish MyTopic --message "Publisher's name is <YOUR NAME>"
gcloud pubsub topics publish MyTopic --message "Publisher likes to eat <FOOD>"
gcloud pubsub topics publish MyTopic --message "Publisher thinks Pub/Sub is awesome"
gcloud pubsub topics publish MyTopic --message "Publisher thinks Pub/Sub is awesome"
```