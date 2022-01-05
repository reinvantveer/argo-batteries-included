SHELL = /bin/bash

.DEFAULT: install

OPERATOR_NAMESPACE ?= operators
DATA_NAMESPACE ?= data
KUBE_CONFIG ?= /etc/rancher/k3s/k3s.yaml

HELM_OPERATE = KUBECONFIG=${KUBE_CONFIG} helm -n ${OPERATOR_NAMESPACE}

all: install

namespaces:
	- kubectl create namespace ${OPERATOR_NAMESPACE}
	- kubectl create namespace ${DATA_NAMESPACE}

dependencies:
	helm dependencies update charts/argo

install:
	${MAKE} namespaces
	${MAKE} dependencies
	$(HELM_OPERATE) install argo charts/argo

uninstall:
	$(HELM_OPERATE) uninstall argo

update:
	$(HELM_OPERATE) upgrade argo charts/argo

clean:
	${MAKE} uninstall
	rm argo/charts/*.tgz

status:
	KUBECONFIG=${KUBE_CONFIG} kubectl get all -A
