# REMLA Course 2025  
## Team-11 
### Assignment-3  

Here are the links to our repositories:

1. operation: https://github.com/remla25-team11/operation/releases/tag/a3 
2. model training: https://github.com/remla25-team11/model-training/tree/a1
3. model service: https://github.com/remla25-team11/model-service/releases/tag/a3
4. lib-ml: https://github.com/remla25-team11/lib-ml/tree/a1
5. lib-version: https://github.com/remla25-team11/lib-version/tree/a1
6. app: https://github.com/remla25-team11/app/releases/tag/a3

## Comments for A3: 

Run with kubernetes

minikube start
minikube addons enable ingress
kubectl apply -f k8s/
minikube ip - application should run on this ip 

Helm Chart
helm install <release-name> ./my_chart

Accessing Prometheus 
kubectl port-forward svc/prometheus-operated -n monitoring 9090
http://localhost:9090
