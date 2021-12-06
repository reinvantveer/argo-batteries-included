# argo-batteries-included

An umbrella helm chart for the Argo ecosystem, with batteries included

## Why?

The Argo ecosystem is an incredibly useful set of tools for managing workflows, events and releases. However, the 
default settings for the Argo Helm charts leave a bit of configuration to set in order to get a working development or
production environment. This Helm chart is intended to help you set up Argo components, with batteries included.

## How?

### Install

For example, use with a [k3s](https://k3s.io/) development environment:
```shell
# Use the k3s kube config, if you use default k3s settings
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Choose a namespace to install to
export NAMESPACE=operators
kubectl create namespace ${NAMESPACE}

# Clone this repo using git clone git@github.com:reinvantveer/argo-batteries-included && cd argo-batteries-included
helm install --namespace=${NAMESPACE} argo charts/argo
```

### Uninstall
```shell
helm uninstall argo
```