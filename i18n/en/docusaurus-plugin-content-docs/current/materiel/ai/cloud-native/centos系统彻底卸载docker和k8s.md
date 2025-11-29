# The centos system completely uninstalls docker and k8s

If you need to completely uninstall Docker and Kubernetes (k8s) on the CentOS system, you can follow the following steps:

1. Uninstall Docker:

   ```bash
   # 停止 Docker 服务
   systemctl stop docker
   systemctl stop docker.socket

   # 卸载 Docker 软件包
   yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

   # 删除 Docker 相关目录
   rm -rf /var/lib/docker
   rm -rf /etc/docker
   ```

2. Uninstall Kubernets:

   ```bash
   # Stop Kubernetes service
   systemctl stop kubelet
   systemctl stop kube-apiserver
   systemctl stop kube-controller-manager
   systemctl stop kube-scheduler
   systemctl stop kube-proxy

   # Uninstall Kubernetes package
   yum remove kubelet kubet kubeadm kubectl

   # Remove Kubernetes related directory
   rm -rf /etc/kubernetes
   rm -rf /lib/etcd
   rm -rf /lib/kubelet 
    rm/kubelet
   ```

3. Clean residue file:

   ```bash
   # Delete docker and Kubernetes associated configuration files and log
   rm -rf /etc/systemd/system/docker.service.d
   rm -rf /etc/systemd/system/system/kubelet.service.d
   rm -rf /var/log/docker
   rm -rf /var/log/docker
   ```

4. Update system configuration:

   ```bash
   # Update systemd configuration
   systemctl daemon-reload
   systemctl reset-failed
   ```

After completing the above steps, your CentOS system should have completely uninstalled Docker and Kubernetes.Please make sure you have cleaned up all relevant components and configuration files on your system before reinstalling them.
