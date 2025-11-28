# cert-manager usage records

[参考地址](https://cert-manager.io/docs/installation/)

## Install

```bash
kubtl apply-f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
```

- Helm installation

```bash
helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.14.4 \
  # --set installCRDs=true
```

# Uninstall

```bash
# Check
kubectl get issuers, ClusterIssuers, Certificates, CertificateRequests,Orders, Challenges --all-namespaces
# Uninstalling with Helm
helm --namespace-manager delete cert-manager
kubectl delete namespace cert-manager
# Uninstalling with kubtl
kubectl delete -f https://github. om/cert-manager/cert-manager/releases/download/vX.Y.Z/cert-manager.crds.yaml
kubectl delete apiservice v1beta.webhook.cert-manager.io
```
