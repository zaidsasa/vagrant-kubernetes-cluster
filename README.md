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
4. [Kubernetes Dashboard](#kubernetes-dashboard): 7.5.0

## Create a Kubernetes practice cluster
To create the cluster, execute the following commands.
```
git clone https://github.com/zaidsasa/kubernetes-practice-environment.git
cd kubernetes-practice-environment
vagrant up
```

## Set Kubeconfig variable
```
export KUBECONFIG=$(pwd)/.vagrant/k8s/config
```

## Kubernetes Dashboard

### Install Kubernetes Dashboard
you can enable it in settings.yaml and running the following:
```
vagrant provision
```

### Access Kubernetes Dashboard
To get the login token, run the following command:
```
kubectl -n kubernetes-dashboard create token admin-user
```
Make the dashboard accessible:
```
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
```
Open the site in your browser:
```
https://localhost:8443/
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
