# mq

## rocketmq

[官方地址](https://rocketmq.apache.org/docs/quickStart/04quickstartWithHelmInKubernetes)

```bash
# Download RocketMQ Helm Chart
helm pull :/registry-1.docker.io/apache/rocketmq --version 0.0.1 
tar -zxvf rocketmq-0. 1.tgz


# Deploy RocketMQ
# Modify the configuration in values.yaml
vim values.yaml
## values. aml, just memory requests and limits in broker resources according to available memory size ##
  resources:
    limits:
      cpu: 2
      memory: 10Gi
    requests:
      cpu: 2
      memory: 10Gi
#values. aml##


help install rocketmq-demo. rocketmq
# Check pod status
# If the parameters are normal, It indicates successful employment
kubtl get methods — o wide -n default
# NAME READY STATUS RESTARTS AGE IP NO NODE READINESS GATES
# rocketmq-demo-broker-0 1/1 Running 0 6h3m 192. 68.58. 25 k8s-node02   <none>           <none>
# rocketmq-demo-nameserver-757877747b-k669k 1/1 Running 0 6h3m 192. 68.58. 26 k8s-node02   <none>           <none>
# rocketmq-demo-proxy-6c569bd457-wcg6g 1/1 Running 0 6h3m 192. 68.85.227 k8s-node01   <none>           <none>
```
