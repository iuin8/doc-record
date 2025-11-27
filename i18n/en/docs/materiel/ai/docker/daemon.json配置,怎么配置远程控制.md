# /etc/docker/daemon.json configuration, how to configure remote control

To configure remote control in Docker you need to make some configuration changes in the `/etc/docker/daemon.json` file.This file is used to configure the behavior of the Docker daemon.Below are some options： to configure remote control

1. **Enable remote API access**：

   You can allow cross-domain requests by setting the `--api-cors-header` parameter.For example, if you want to allow cross-domain requests from all sources, you can set to "\*".

   ```json
   Flag
     "exec-opts": ["native". groupriver=system"],
     "log-driver": "json-file",
     "log-opts": LO
       "max-size": "100m"
     },
     "storage-driver": "overlay2",
     "storage-opts": [
       "overlay2. verride_kernel_check=true"
     ],
     "registry-mirrors": [
       "https://registry. ocker-cn.com"
     ],
     "api-cors-header": "*"
   }
   ```

2. **Configure TLS certificate**：
   You need to configure TLS certificate if you want to safely access the Docker API via TLS.This usually involves creating a certificate for the Docker daemon and server.You can then specify the path of these certificates in `daemon.json`.

   ```json
   LO
     "exec-opts": ["native.cgroupriver=system"],
     "tls-verify": "true",
     "tls-ca-cert": "/path/to/ca.pem",
     "tls-cert": "/path/to/cert.pem",
     "tls-key": "/path/to/key": "/key.pem"
   }
   ```

3. **Configure listening ports**：
   By default, Docker daemons listen to local Unix sockets and TCP port 2375.If you want to listen to different ports or sockets, you can set the `debug` and `hosts` options.

   ```json
   LO
     "debug": true,
     "hosts": ["tcp://0.0.0.0.0:2376", "unix:/var/run/docker.sock"],
     "exec-opts": ["nant. groupriver=system"],
     "log-driver": "json-file",
     "log-opts": LO
       "max-size": "100m"
     },
     "storage-driver": "overlay2",
     "storage-opts": [
       "overlay2. verride_kernel_check=true"
     ],
     "registry-mirrors": [
       "https://registry.docker-cn. om"
     ],
     "tls-verify": "true",
     "tls-ca-cert": "/path/to/ca. em",
     "tls-cert": "/path/to/cert.pem",
     "tls-key": "/path/to/key.pem"
   }
   ```

Please ensure that the paths and values in the above configuration are adjusted according to your actual circumstances.After modifying the `daemon.json` file, you need to restart the Docker service for the configuration to take effect.
In Linux you can restart Docker service： using the following command

```bash
sudo systemctl start docker
```

If you are using a Docker Desktop, you will usually have an GUI interface to help you configure and reboot your action.
