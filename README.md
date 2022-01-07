# Argo: batteries included

## What?

This repo contains two "educational" helm charts, useful for exploration, local development and testing. 

1. The first chart is simply called "argo" here. Applications like Argo Workflows can be quite tricky to set up, so once
   you have a working dev system, it becomes easier to experiment with, and adapt it to your liking and production
   environment requirements so that it offers a clear migration path. For details on what applications are deployed with
   the `argo` chart, see the [Argo chart README.md](charts/argo/README.md).

2. A second `argo-event-based-operator` chart is provided, containing an example on how to use Argo Workflows in
   conjunction with Argo Events to create
   a [Kubernetes Operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/). 

The purpose of this repo is to provide an "umbrella helm chart" for a local dev/test setup of the Argo ecosystem, with
batteries included. This allows you to freely experiment and muck around without requiring access to a full cloud
cluster. All applications work out of the box. Hints on application logins are provided by the installation [NOTES.txt](charts/argo/templates/NOTES.txt).

## NOTE ON SECURITY

The Agro-batteries-included chart is for education, experimentation and exploration only. **Do NOT under any
circumstance use this chart for ANY kind of production environment!** Although every single component used can be
configured in a secure manner, it is insecure in this chart due to the configuration provided here:

- dead giveaway default passwords,
- exposed endpoints,
- missing database backups,
- insecure authentication and/or
- disabled authentication.

Please check every security setting, if possible with your cloud security engineer in order to reshape the
settings [provided here](charts/argo/values.yaml) into a security-hardened setup. Make sure you enable TLS encryption
where applicable and available, disable the default password settings and disable every Ingress that should not expose
infrastructure to the outside world.

## Why?

The Argo ecosystem is an incredibly useful set of tools for managing workflows, events and releases. However:

1. The default settings for the Argo Helm charts leave quite a bit of configuration and tweaking to set in order to get
   a working development environment. This Helm chart is intended to help you set up full-featured Argo components, with
   batteries included.
2. Also: this chart is targeted specifically at local "bare metal" or minimal development or testing installation
   environments, rather than full-scale large cloud clusters. Once you reach _that_ stage, you have probably (re-)visited
   every [configuration setting](charts/argo/values.yaml) that this chart provides as a "getting started" resource.
3. I scratched an itch I had for a while. With Argo Events and Argo Workflows, you can replace basically any operator
   framework with something that has a lot better logging and archiving, is much more transparent, has less code you
   need to be concerned with (much of it is, admittedly, hidden in the Argo applications) and is much more
   multi-purpose. The result of this itch is in
   the [`argo-event-based-operator`](charts/argo-event-based-operator/README.md) chart.

## How?

For now, I've decided to run with a simple Makefile approach, which keeps things extremely simple. After installing

- [k3s](https://rancher.com/docs/k3s/latest/en/installation/) (tested),
  [minikube](https://minikube.sigs.k8s.io/docs/start/) (untested), [minik8s](https://microk8s.io/) (never tried) or any
  other installation that provides a Kubernetes control plane, 
- and [Helm](https://helm.sh/docs/intro/install/)

you can start hacking!

### Installing the Argo chart

```shell
make install
```

and the entire umbrella chart is deployed. This also takes care of creating the `operators` and `data` namespaces. If
you want to install to other namespaces, you need to either edit or override the settings in both the 
[Makefile](Makefile) and [charts/argo/values.yaml](charts/argo/values.yaml).

### Uninstalling the Argo chart

```shell
make uninstall
```

This will not delete the `operators` and `data` namespaces, in case you started deploying other stuff there as well.
Also: the data volume for PostgreSQL is kept, so the Workflow archive is still present. It does, however, delete the
MinIO bucket data.

### Updating the Argo chart
Once you have deployed and want to tweak the deployment settings, you can update the Argo release using 

```shell
make update
```


### TODO

- [ ] Easy reconfigurable support for installing into namespaces other than `operators` and `data`.
- [ ] Easily configurable way to keep MinIO persistent volumes after uninstall. Something to do with the deletion policy
  of the PV(C).
- [ ] Metrics for services
