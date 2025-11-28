# command line tool when k8s container is running

On containerd running

```bash
# List all containers
crictl ps
```

- Configure unsafe mirror repository

```bash
mkdir /etc/containerd/
# Write to default configuration
containerd config default > /etc/containerd/config.toml
# Modify configuration file
# [plugins."io.containerd.grpc.v1. ri".registry]
# [plugins."io.containerd.grpc.v1.cr".registry.mirrors]
# [plugins."io.containainerd.grpc.v1.cr".registry."dock". o"]
# endpoint = [https://registry-1.docker. o"]
# Add the following subject
# [plugins."io.containerd.grpc.v1.cr".registry.mirrors."harbor. arbor6"]
# endpoint = ["http://harbor. arbor6"]
# Restart
systemctl daemon-reload
systemctl restart containerd.service

```

```bash
# Port Configuration
        [plugins."io.containerd.grpc.v1.cr".registry.mirrors."harbor.harbor6:30003"]
          endpoint = ["http://harbor.harbor6:30003"]
```
