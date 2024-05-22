# Kubernetes Practice Environment

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/zaidsasa/kubernetes-practice-environment/blob/main/LICENSE)

Practice environment for Kubernetes Certifications including CKA, CKAD, and CKS.

## Prerequisites

1. [vagrant]
2. [virtualbox]

[vagrant]: https://developer.hashicorp.com/vagrant/install
[virtualbox]: https://www.virtualbox.org/wiki/Downloads

## What is included?

1. Container Runtime Interface (CRI): cri-o
2. Container Network Interface (CNI): calico 3.28.0 (Default)
3. Kubernetes: 1.29 (Default)

## Create a Kubernetes practice cluster
To create the cluster, execute the following commands.
```
git clone https://github.com/zaidsasa/kubernetes-practice-environment.git
cd kubernetes-practice-environment
vagrant up
```

## Set Kubeconfig variable
```
export KUBECONFIG=$(pwd)/.tmp/kube-config
```

## Kubernetes Dashboard

### Install Kubernetes Dashboard
you can enable it in settings.yaml and running the following:
```
vagrant provision controlplane
```

### Access Kubernetes Dashboard
To get the login token, run the following command:
```
kubectl -n kubernetes-dashboard get secret/admin-user -o go-template="{{.data.token | base64decode}}"
```
Make the dashboard accessible:
```
kubectl proxy
```
Open the site in your browser:
```
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=kubernetes-dashboard
```

## To shutdown the cluster
```
vagrant halt
```

## To destroy the cluster
```
vagrant destroy -f
```

## Contributing

Please feel free to submit issues, fork the repository and send pull requests!

## License

This project is licensed under the terms of the MIT license.
