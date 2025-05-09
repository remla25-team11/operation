# REMLA Kubernetes Cluster Setup Guide

This README documents how to provision and test a local multi-node Kubernetes cluster using Vagrant, Ansible, and kubectl for the REMLA team project.

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

1. Set the kubeconfig path:

```bash
export KUBECONFIG=./vagrant/admin.conf
```

2. Test cluster connectivity:

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

---

