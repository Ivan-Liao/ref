1. Setup
```
docker run hello-world
docker images
docker run hello-world # this time from local


docker ps
docker ps -a
```
2. Build an image
```
mkdir test && cd test
cat > Dockerfile <<EOF
# Use an official Node runtime as the parent image
FROM node:lts

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Make the container's port 80 available to the outside world
EXPOSE 80

# Run app.js using node when the container launches
CMD ["node", "app.js"]
EOF
```
3. Code app.js
```
cat > app.js << EOF;
const http = require("http");

const hostname = "0.0.0.0";
const port = 80;

const server = http.createServer((req, res) => {
	res.statusCode = 200;
	res.setHeader("Content-Type", "text/plain");
	res.end("Hello World\n");
});

server.listen(port, hostname, () => {
	console.log("Server running at http://%s:%s/", hostname, port);
});

process.on("SIGINT", function () {
	console.log("Caught interrupt signal and will exit");
	process.exit();
});
EOF
```
4. Build and run image
```
docker build -t node-app:0.1 .
docker images
docker run -p 4000:80 --name my-app node-app:0.1
curl http://localhost:4000
docker stop my-app && docker rm my-app
docker run -p 4000:80 --name my-app -d node-app:0.1
docker ps
docker logs [container_id]
```
5. Modifications
```
cd test
# edit app.js 
const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Welcome to Cloud\n');
});


docker build -t node-app:0.2 .
docker run -p 8080:80 --name my-app-2 -d node-app:0.2
docker ps
curl http://localhost:8080
curl http://localhost:4000
```
6. Debug
```
docker logs -f [container_id]
docker exec -it [container_id] bash
ls
exit
docker inspect [container_id]
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [container_id]
```
7. Publish
```
gcloud auth configure-docker "REGION"-docker.pkg.dev
gcloud artifacts repositories create my-repository --repository-format=docker --location="REGION" --description="Docker repository"
cd ~/test
docker build -t "REGION"-docker.pkg.dev/"PROJECT_ID"/my-repository/node-app:0.2 .
docker images
docker push "REGION"-docker.pkg.dev/"PROJECT_ID"/my-repository/node-app:0.2


docker stop $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi "REGION"-docker.pkg.dev/"PROJECT_ID"/my-repository/node-app:0.2
docker rmi node:lts
docker rmi -f $(docker images -aq) # remove remaining images
docker images
docker run -p 4000:80 -d "REGION"-docker.pkg.dev/"PROJECT_ID"/my-repository/node-app:0.2
curl http://localhost:4000
```