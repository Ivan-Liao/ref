1. Setup
```
gcloud services enable appengine.googleapis.com
git clone https://github.com/GoogleCloudPlatform/php-docs-samples.git
cd php-docs-samples/appengine/standard/helloworld
sed -i 's/^runtime: php.*/runtime: php83/' app.yaml
grep runtime app.yaml
```

2. Deploy
```
gcloud app deploy
gcloud app browse
```

3. Edits
```
nano index.php
change "hello world!" to "goodbye world!"

gcloud app deploy
```