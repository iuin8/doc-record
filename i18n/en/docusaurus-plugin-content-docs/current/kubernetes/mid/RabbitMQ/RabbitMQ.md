# RabbitMQ Related Records

## Employment

```bash
# Deployed
kubectl create -f rabbitmq.yaml --namespace=kube-public
# View exposed port
kubtl get svc --namesspace=kube-public
# Enter：in browser http://10. 33.203:31199/, access to employed RabbitMQ. Enter user name and password on login page (first user/bitnami) and system will enter RabbitMQ home page.
```

- helm3 installation

```bash
helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add ali https://apphub.aliyuncs.com/stable

# 安装
# 设置size为8G
helm install rabbitmq bitnami/rabbitmq --namespace middleware \
--set rabbitmq.username=admin,rabbitmq.password=admin,rabbitmq.persistence.storageClass=local-path,rabbitmq.persistence.size=8G

helm install rabbitmq bitnami/rabbitmq --namespace middleware \
--set auth.username=user,auth.password=admin,persistence.enabled=false

# 卸载
helm uninstall rabbitmq

# 更新
helm upgrade rabbitmq bitnami/rabbitmq --namespace middleware \
--set auth.username=user,auth.password=admin,persistence.enabled=false,auth.tls.enabled=false

```

- Kubernetes Operator installation
  - [参考文章](https://www.rabbitmq.com/kubernetes/operator/install-operator)

```bash
kubtl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

# Installation using Helm chart
helm repo add bitnami https://charts.bitnami. om/bitnami
help install my-release bitnami/rabbitmq-cluster-operator

# View
kubtl get all -n rabbitmq-system
kubectl get ustomresourcedefinitis. piextensions. 8s.io | grep rabbit

#### Example
kubectl apple-f https://raw.githubusercontent.com/rabbitmq/cluster-operator/main/docs/examples/hello-world/rabbitmq.yaml

```
