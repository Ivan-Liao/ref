1. Setup
```
gcloud storage cp -r gs://spls/gsp053/kubernetes .
cd kubernetes


gcloud container clusters create bootcamp \
  --machine-type e2-small \
  --num-nodes 3 \
  --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"


kubectl explain deployment
kubectl explain deployment --recursive
kubectl explain deployment.metadata.name
```
2. Create a deployment
```
cat deployments/fortune-app-blue.yaml
kubectl create -f deployments/fortune-app-blue.yaml
kubectl get deployments
kubectl get replicasets
kubectl get pods
kubectl create -f services/fortune-app.yaml
kubectl get services fortune-app
curl http://<EXTERNAL-IP>/version
curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version


# scale 
kubectl scale deployment fortune-app-blue --replicas=5
kubectl get pods | grep fortune-app-blue | wc -l
kubectl scale deployment fortune-app-blue --replicas=3
kubectl get pods | grep fortune-app-blue | wc -l


# rolling update
kubectl edit deployment fortune-app-blue
kubectl get replicaset
kubectl rollout history deployment/fortune-app-blue


kubectl rollout pause deployment/fortune-app-blue
kubectl rollout status deployment/fortune-app-blue
for p in $(kubectl get pods -l app=fortune-app -o=jsonpath='{.items[*].metadata.name}'); do echo $p && curl -s http://$(kubectl get pod $p -o=jsonpath='{.status.podIP}')/version; echo; done
kubectl rollout resume deployment/fortune-app-blue
kubectl rollout status deployment/fortune-app-blue
kubectl rollout undo deployment/fortune-app-blue
curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
```
3. OTher Deployments
```
cat deployments/fortune-app-canary.yaml
kubectl create -f deployments/fortune-app-canary.yaml
kubectl get deployments
for i in {1..10}; do curl -s http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version; echo;
done


# blue-green
kubectl apply -f services/fortune-app-blue-service.yaml
kubectl create -f deployments/fortune-app-green.yaml
curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
kubectl apply -f services/fortune-app-green-service.yaml
curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
kubectl apply -f services/fortune-app-blue-service.yaml
curl http://`kubectl get svc fortune-app -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
```
4. References
```
# example kubernetes deployment yaml file

# orchestrate-with-kubernetes/kubernetes/deployments/fortune-app-blue.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fortune-app-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: fortune-app
  template:
    metadata:
      labels:
        app: fortune-app
        track: stable
        version: "1.0.0"
    spec:
      containers:
        - name: fortune-app
          # The new, centralized image path
          image: "us-central1-docker.pkg.dev/qwiklabs-resources/spl-lab-apps/fortune-service:1.0.0"
          ports:
            - name: http
              containerPort: 8080
          env:
            - name: APP_VERSION
              value: "1.0.0"
          resources:
            limits:
              cpu: "0.2"
              memory: "20Mi"
          readinessProbe:
            httpGet:
              path: /
              port: 8080
            initialDelaySeconds: 5
```
```
# external service
# orchestrate-with-kubernetes/kubernetes/services/fortune-app.yaml
kind: Service
apiVersion: v1
metadata:
  name: "fortune-app"
spec:
  selector:
    # This selector will grab pods from both blue and canary deployments
    app: "fortune-app"
  ports:
    - protocol: "TCP"
      port: 80
      targetPort: 8080
```