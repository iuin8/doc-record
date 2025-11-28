# jenkins use

## Helm employment

```bash
# Add Jenkins repository：
help repo ad jenkinsci https://charts.jenkins. o && help repo update
# Deemployment Jenkins：
helm install jenkins jenkins jenkins jenkinsci/jenkins
# Check Jenkins：Use help list to check Jenkins employment status, Check Jenkins state
# See ip and port
kubectl get svc jenkins
# port map
kubectl --namespace default port-forward svc/jenkins 800:80
# View note message
helm get notes jenkins

# Uninstall Jenkins
helm uninstall jenkins
```
