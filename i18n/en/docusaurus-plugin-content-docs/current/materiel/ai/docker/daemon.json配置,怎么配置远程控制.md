# /etc/docker/daemon.json configuration, how to configure remote control

To configure remote control in Docker you need to make some configuration changes in the `/etc/docker/daemon.json` file. His file is used to configure the behaviour of the Docker daemon. Below are some options： to configure remote control

1. **Enable remote API access**：

   You can allow cross-domain requests by setting the `--api-cors-header` parameter. or example, if you want to allow cross-domain requests from all sources, you can set to "\*".

   ```json
   Flag
     "exec-opts": ["native". grouppriver=system"],
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
   You need to configure TLS certificate if you want to safely access the Docker API via TLS. He is involved in creating a certificate for the Docker daemon and server. You can specify the path of these certificates in `daemon.json`.

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
   By default, Docker daemons list to local Unix sockets and TCP port 2375. f You want to list different ports or sockets, you can set the `debug` and `hosts` options.

   ```json
   LO
     "debug": true,
     "hosts": ["tcp://0.0.0.0.0.0.0.0.0.0.0,", "unix:/var/run/docker.sock"],
     "exec-opts": ["nant. grouppriver=system"],
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

Please ensure that the paths and values in the above configuration are justified according to your actual circumstances.After modifying the `daemon. son` file, you need to restart the Docker service for the configuration to take effect.
In Linux you can start Docker service： using the following command.

```bash
sudo systemctl start docker
```

If you are using a Docker Desktop, you will have an GUI interface to help you configure and reboot your action.
