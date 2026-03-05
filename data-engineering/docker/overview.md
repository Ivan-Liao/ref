1. Container Management
   1. Stopping and removing all docker processes (full clean)
```
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
```
   2. Removing all images
      1. `docker rmi -f $(docker images -aq)`