# REMLA Kubernetes Cluster Setup Guide

This README documents how to provision and test a local multi-node Kubernetes cluster using Vagrant, Ansible, and kubectl for the REMLA team project.

---

## Running with Kubernetes

### Prerequisites

Before starting, make sure that minikube is running and that the Ingress addon is enabled

```bash
minikube start
minikube addons enable ingress
```

### Applying Kubernetes manifests

From the repository root (`operation/`) run:
```bash
kubectl apply -f k8s/
```

### Accessing the application

Find the minikube IP by running:
```bash
minikube ip
```

Then use that IP in your browser to access the application. 

#MacOS

Use a minikube tunnel and connect to the application using the localhost.

```
minikube tunnel
```

---
## Deploying with Helm Chart
Currently Helm is set to run on port 80. This can be changed in the values.yaml file.

### Prerequisites
- A running Kubernetes cluster
- kubectl configured
- Helm installed

### Deploying
In order to run the application to deploy the application using Helm do:
```bash
helm install <release-name> ./my_chart
```
To stop:
```bash
helm uninstall <release-name>
```

---

## Cluster Overview

* 1 control plane: `ctrl` @ 192.168.56.100
* 2+ worker nodes: `node-1`, `node-2`, ... @ 192.168.56.10X
* Base image: `bento/ubuntu-24.04`
* Networking: Host-only private network

---

## VM Management (Vagrant)

From the `operation/vagrant/` directory:

```bash
vagrant up                # Start with default 2 workers
NUM_WORKERS=3 vagrant up  # Start with custom number of workers
vagrant ssh ctrl          # SSH into controller
vagrant ssh node-1        # SSH into first worker
vagrant destroy -f        # Destroy all VMs
```

---

## Provision VMs with Ansible

From the `operation/` directory:

```bash
ansible-playbook -i ansible/inventory.cfg ansible/ctrl.yaml
ansible-playbook -i ansible/inventory.cfg ansible/node.yaml
```

The `node.yaml` playbook automatically handles the cluster join logic using:

* `delegate_to: ctrl` to run `kubeadm token create` on the controller
* `register: join_command` to capture the join command output
* `shell: "{{ join_command.stdout }}"` to run the command on each worker

If a node is already joined or needs a reset, you may need to manually clean it up (see README comments).

---

## SSH Key Registration (Team Access)

1. Place public keys in `ansible/ssh_keys/`, e.g.:

```bash
cp ~/.ssh/id_rsa.pub ansible/ssh_keys/sowmya.pub
```

2. Run the key registration playbook:

```bash
ansible-playbook -i ansible/inventory.cfg ansible/general.yaml
```

3. Teammates can then connect via SSH:

```bash
ssh -i ~/.ssh/id_rsa vagrant@192.168.56.101
```

---

## kubectl Setup (on Host)

1. Apply Flannel CNI:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

2. Set the kubeconfig path:

```bash
export KUBECONFIG=./vagrant/admin.conf
```

3. Test cluster connectivity:

```bash
kubectl get nodes
```

---

## Deploy a Sample App

```bash
kubectl create deployment hello-nginx --image=nginx
kubectl expose deployment hello-nginx --type=NodePort --port=80
kubectl get services
```

Visit the service at:

```
http://192.168.56.101:<NodePort>
```

## Install Prometheus

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
```

## Accessing Prometheus

```bash
kubectl port-forward svc/prometheus-operated -n monitoring 9090
```

Open the dashboard at:

```bash
http://localhost:9090/targets
```

## Grafana Dashboard

Start port-forwarding Grafana:

```bash
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
```

Open browser at:

```bash
http://localhost:3000
```

To retrieve credentials:

```bash
kubectl get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode
```

Go to Dashboards → Manage, and open the pre-installed dashboard named "Dashboard"

# Manual Import 

To import the dashboard:

1. Run:

   ```bash
   kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
    ```
Go to http://localhost:3000 and log in.

Navigate to Dashboards → Import.

Upload grafana/dashboards/app-dashboard.json.

## Select Prometheus as the data source and click Import.


## Sticky Sessions Istio

#### Prerequisites

Make sure you have:

1. Istio installed (if not):

   ```bash
   istioctl install --set profile=demo -y
   ```
2. Sidecar injection enabled:

```bash
kubectl label namespace default istio-injection=enabled
```
3. Apply Gateway, VirtualService, DestinationRule:

   ```bash
   kubectl apply -f k8s/istio-gateway.yaml
   kubectl apply -f k8s/virtual-service-app.yaml
   kubectl apply -f k8s/destination-rule-app.yaml
   ```

## If you are on macOS or using Minikube, run:

```bash
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
```

### Always routes to app v2

```bash
curl -H "user: test-user" http://localhost:8080/version
```

### Always routes to app v1
```bash
curl http://localhost:8080/version
```

---
