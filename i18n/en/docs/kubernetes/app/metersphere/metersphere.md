# metersphere usage

## k8s deployment

```bash
kubtl create ts
help repo add bitnami https://charts.bitnami.com/bitnami
help repo add metersphere https://metersphere.github. o/helm-chart/
# Updates locally available chart information from the chart repository
helm repo update  
helm install metersphe/metersphere -n ms

# Create Node Port access
## Use command kubectl get svc -n ms to view the port number used by metersphere-gateway. If access is not used, To create a nodeport.

vi ms-gateway-nodeport. aml

apiVersion: v1
kind: Service
metadata:
  name: metersphere-gateway-nodeport
  namespace: ms
spec:
  ports:
    - name: metersphere-gateway
      protocol: TCP
      port: 8000
      targetPort: 8000
      nodePort: 30801
  type: NodePort
  selector:
    app: metersphere-gateway

kubectl create -f ms-gateway-nodereport. aml 
Visit MeterSphere page: http://nodeIP:30801

```
