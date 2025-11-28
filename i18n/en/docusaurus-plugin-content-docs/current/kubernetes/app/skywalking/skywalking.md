# skywalking usage record

## Install

- Quick Start

[Quick Start](https://skywalking.apache.org/docs/skywalking-showcase/next/readme/#quick-start)

```bash
git clone https://github.com/apache/skywalking-showcase.git
cd skywalking-showcase
make employ.kubernetes
```

[skywalking-helm](https://github.com/apache/skywalking-helm/tree/v4.5.0)

```bash
# 创建命名空间
kubectl create namespace skywalking

# 设置环境变量
export SKYWALKING_RELEASE_VERSION=4.3.0
export SKYWALKING_RELEASE_NAME=skywalking
export SKYWALKING_RELEASE_NAMESPACE=skywalking

# 执行安装
helm install "${SKYWALKING_RELEASE_NAME}" \
  oci://registry-1.docker.io/apache/skywalking-helm \
  --version "${SKYWALKING_RELEASE_VERSION}" \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=9.2.0 \
  --set oap.storageType=elasticsearch \
  --set ui.image.tag=9.2.0
```

- Install SkyWalking development version using master branch

```bash
export REPO=chart
git clone https://github.com/apache/skywalking-kubernetes
cd skywalking-kubernetes
helm repo add elastic https://helm.elastic.co
helm dep up ${REPO}/skywalking
```

- Install a specific version of SkyWalking using the existing Elasticsearch

Modify the connection information for the elasticsearch cluster in the file values-my-es.yaml.
\- [values-my-es.yaml](https://github.com/apache/skywalking-helm/blob/v4.5.0/chart/skywalking/values-my-es.yaml)

```bash
export SKYWALKING_RELEASE_NAME=skywalking
export SKYWALKING_RELEASE_NAMESPACE=skywalking
export REPO=chart
git clone https://github.com/apache/skywalking-kubernetes
cd skywalking-kubernetes
helm install "${SKYWALKING_RELEASE_NAME}" ${REPO}/skywalking -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  -f ./${REPO}/skywalking/values-my-es.yaml
```

```bash
# 方式二(目前用的方式)

# 设置环境变量
export SKYWALKING_RELEASE_VERSION=4.3.0
export SKYWALKING_RELEASE_NAME=skywalking
export SKYWALKING_RELEASE_NAMESPACE=skywalking
export ELASTICSEARCH_CONFIG_HOST=10.0.1.90

helm install "${SKYWALKING_RELEASE_NAME}" \
  oci://registry-1.docker.io/apache/skywalking-helm \
  --version "${SKYWALKING_RELEASE_VERSION}" \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.tag=9.2.0 \
  --set oap.storageType=elasticsearch \
  --set elasticsearch.enabled=false \
  --set elasticsearch.config.host="${ELASTICSEARCH_CONFIG_HOST}" \
  --set elasticsearch.config.user="" \
  --set elasticsearch.config.password="" \
  --set ui.image.tag=9.2.0
```

```bash

# 设置环境变量
export SKYWALKING_RELEASE_NAME=skywalking
export SKYWALKING_RELEASE_NAMESPACE=skywalking

helm upgrade "${SKYWALKING_RELEASE_NAME}" \
  oci://registry-1.docker.io/apache/skywalking-helm \
  --version "4.5.0" \
  -n "${SKYWALKING_RELEASE_NAMESPACE}" \
  --set oap.image.repository="apache/skywalking-oap-server" \
  --set oap.image.tag=latest \
  --set oap.storageType=elasticsearch \
  --set elasticsearch.enabled=false \
  --set elasticsearch.config.host="10.0.1.90" \
  --set elasticsearch.config.user="" \
  --set elasticsearch.config.password="" \
  --set ui.image.repository="apache/skywalking-ui" \
  --set ui.image.tag=latest \
  --set satellite.enabled=true \
  --set satellite.image.repository="apache/skywalking-satellite" \
  --set satellite.image.tag=v1.2.0


```
