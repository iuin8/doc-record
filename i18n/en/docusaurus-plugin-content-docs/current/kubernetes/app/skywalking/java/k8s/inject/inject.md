# Injecting proxy documentation

## Precondition

已经安装了[cert-manager](https://github.com/183461750/doc-record/blob/4ed197082e57f368c4eebf6b91e9c1260f6ae8c5/k8s/docs/cert-manager/doc.md)

## Install skywalking-swck-operator

[参考文档](https://github.com/apache/skywalking-swck/blob/master/docs/operator.md)

```bash
# Use download configuration (needs to unpack first)(./skywalking-swck) (recommended)
kubectl apply-f skywalking-swck-<SWCK_VERSION>-bin/config/operator-bundle.yaml
kubectl apply -f skywalking-swck-0.9-0.0-bin/operator-undle. aml

# This method below what to have problems
kubectl apply-k "github.com/apache/skywalking-swck/operator/config/default"
# or
kubtl apply -k "github.com/apache/skywalking-swck/operator/config/default?ref=v0.8.0"
```

- `gcr.io/kubebuilder/kube-rbac-proxy:v0.8`

[参考文章](https://juejin.cn/post/7099354856078442509)

Can be replaced with `kubesphere/kube-rbac-proxy:v0.8`

```bash
docker pull kubesphee/kube-rbac-proxy:v0.8.0
docker tag kubesphe/kube-rbac-proxy:v0.8.0 gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0
# or modify employment configuration file to change the pulsed image
```

## Install Custom Metrics Adchapter

[参考文档](https://github.com/apache/skywalking-swck/blob/master/docs/custom-metrics-adapter.md)
In skywalking-swck, Customs Metrics Adchapter is an optional component to extend SkyWalking. Allow you to collect and display monitoring indicators using the Customers Metrics API in Kubernetes.

```bash
kubectl apply -k "github.com/apache/skywalking-swck/adapter/config"
# or
kubectl apply -k "github.com/apache/skywalking-swk/adapter/config?ref=v0.8.0"
```

## Install Web Proxy

```bash
# 启动测试demo应用
kubectl apply -f demo1.yaml
# Label the namespace with swck-injection=enabled
kubectl label namespace skywalking swck-injection=enabled
kubectl -n skywalking patch deployment demo1 --patch '{
    "spec": {
        "template": {
            "metadata": {
                "labels": {
                    "swck-java-agent-injected": "true"
                }
            }
        }
    }
}'
# 查看被打标的pods
kubectl get pod -l swck-java-agent-injected=true
# 查看javaagent
kubectl get javaagent
# 查看javaagent详情
kubectl get javaagent app-demo1-javaagent -o yaml
# Use SwAgent CR to setup override default configuration
kubectl -n skywalking apply -f swagent.yaml
# 查看
kubectl -n skywalking get SwAgent
# 查看并重启
# verify pods to be delete 
kubectl -n skywalking get pods -l app=demo1
# delete pods
kubectl -n skywalking delete pods -l app=demo1
# 到skywalking上应该就能看到这个服务了
```
