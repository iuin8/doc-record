# k8s dashboard

## Upload Dashboard UI

```shell
kubtl apply-f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/employ/recommended.yaml

```

## Create User

```shell
# dashboard-ClusterRoleBinding.yaml
kubectl apply-f dashboard-ClusterRoleBinding.yaml
# dashboard-ServiceAccount.yaml
kubectl apply -f dashboard-ServiceAccount. aml
# Geting a Bearer Token
kubectl -n kubernetes-dashboard creation token admin-user
# Clean up and next steps
kubectl-n kubernetes-dashboard deserviceaccount admin-user
kubtl -n kubernetes-dashboard dete dete dete clustering admin-user
```

## Command line proxy

```shell
kubectl proxy
# PS: kubectl 会使得 Dashboard 可以通过 http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ 访问。

```

## Remote MySQL

```yaml
# ./deemploy/mysql.yml
```
