1. Setup
```
docker run hello-world
docker images
docker run hello-world # this time from local


docker ps
docker ps -a # shows finished run executions
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



[
    {
        "Id": "65c6eee663c46e17b46ee95a16c3ec444e1d12c10236c5f6f59e7cc03ed511bb",
        "Created": "2026-03-05T17:09:49.592753948Z",
        "Path": "docker-entrypoint.sh",
        "Args": [
            "node",
            "app.js"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 2014,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2026-03-05T17:09:49.658465598Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:4d3640db90d9e3a7e3c3686b29d32456ddd926a89f1568a6b55bfc255902aa25",
        "ResolvConfPath": "/var/lib/docker/containers/65c6eee663c46e17b46ee95a16c3ec444e1d12c10236c5f6f59e7cc03ed511bb/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/65c6eee663c46e17b46ee95a16c3ec444e1d12c10236c5f6f59e7cc03ed511bb/hostname",
        "HostsPath": "/var/lib/docker/containers/65c6eee663c46e17b46ee95a16c3ec444e1d12c10236c5f6f59e7cc03ed511bb/hosts",
        "LogPath": "/var/lib/docker/containers/65c6eee663c46e17b46ee95a16c3ec444e1d12c10236c5f6f59e7cc03ed511bb/65c6eee663c46e17b46ee95a16c3ec444e1d12c10236c5f6f59e7cc03ed511bb-json.log",
        "Name": "/my-app",
        "RestartCount": 0,
        "Driver": "overlayfs",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "bridge",
            "PortBindings": {
                "80/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "4000"
                    }
                ]
            },
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "ConsoleSize": [
                33,
                246
            ],
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "private",
            "Dns": null,
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": [],
            "BlkioDeviceWriteBps": [],
            "BlkioDeviceReadIOps": [],
            "BlkioDeviceWriteIOps": [],
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": null,
            "PidsLimit": null,
            "Ulimits": [],
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/acpi",
                "/proc/asound",
                "/proc/interrupts",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/sys/devices/virtual/powercap",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "Storage": {
            "RootFS": {
                "Snapshot": {
                    "Name": "overlayfs"
                }
            }
        },
        "Mounts": [],
        "Config": {
            "Hostname": "65c6eee663c4",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NODE_VERSION=24.14.0",
                "YARN_VERSION=1.22.22"
            ],
            "Cmd": [
                "node",
                "app.js"
            ],
            "Image": "node-app:0.1",
            "Volumes": null,
            "WorkingDir": "/app",
            "Entrypoint": [
                "docker-entrypoint.sh"
            ],
            "Labels": {}
        },
        "NetworkSettings": {
            "SandboxID": "a9f700919dcdb7ce006ba0acde6d71353c5dd570149a3f6910b0dbf16dfd9893",
            "SandboxKey": "/var/run/docker/netns/a9f700919dcd",
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "4000"
                    }
                ]
            },
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "DriverOpts": null,
                    "GwPriority": 0,
                    "NetworkID": "acd117724828155f58301ae1fc0ac08fe948b31e6161d2823bd7cc0e9e44f910",
                    "EndpointID": "de2b454670ff47b40caf0a8f8d239caf4684d3b5089271bc01b2d2586bda1537",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "MacAddress": "de:8f:65:34:10:6b",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
            }
        },
        "ImageManifestDescriptor": {
            "mediaType": "application/vnd.oci.image.manifest.v1+json",
            "digest": "sha256:a2e2b9f0a089a0ff603839372c217a5fc55012b0bd9fc50b01096c57fe80a1f0",
            "size": 2199,
            "platform": {
                "architecture": "amd64",
                "os": "linux"
            }
        }
    }
]