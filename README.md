# Argo: batteries included

This repo contains an "educational" helm chart, useful for exploration, local development and testing. Applications like
Argo Workflows can be quite tricky to set up, so once you have a working local system, it becomes easier to experiment
with, and adapt it to your liking and production environment requirements so that it offers a clear migration path. 

The purpose of this repo is to provide an "umbrella helm chart" for a local dev/test setup of the Argo ecosystem, with
batteries included. This allows you to freely experiment and muck around without requiring access to a full cloud
cluster. All applications work out of the box. Hints on application logins is provided by the installation notes itself.

For details on what applications are deployed with this chart, see the [What](#what) section below.

## NOTE ON SECURITY

This chart is for education, experimentation and exploration only. **Do NOT under any circumstance use this chart for
ANY kind of production environment!** Although every single component used can be configured in a secure manner, it is
insecure in this chart due to the configuration provided here: 
- dead giveaway default passwords, 
- exposed endpoints, 
- missing database backups, 
- insecure authentication and/or 
- disabled authentication. 

Please check every security setting, if possible with your cloud security engineer in order to reshape the
settings [provided here](charts/argo/values.yaml)
into a security-hardened setup. Make sure you enable TLS encryption where applicable and available, disable the default
password settings and disable every Ingress that should not expose infrastructure to the outside world.

## Why?

The Argo ecosystem is an incredibly useful set of tools for managing workflows, events and releases. However:

1. The default settings for the Argo Helm charts leave quite a bit of configuration to set in order to get a working
   development environment. This Helm chart is intended to help you set up full-featured Argo components, with batteries
   included.
2. Also: this chart is targeted specifically at local "bare metal" or minimal development or testing installation
   environments, rather than full-scale large cloud clusters. Once you reach _that_ stage, you have probably (re-)visited
   every [configuration setting](charts/argo/values.yaml) that this chart provides as a "getting started" resource.

## How?

For now, I've decided to run with a simple Makefile approach, which keeps things extremely simple. After installing

- [k3s](https://rancher.com/docs/k3s/latest/en/installation/) (tested)
  or [minikube](https://minikube.sigs.k8s.io/docs/start/) (untested),
- and [Helm](https://helm.sh/docs/intro/install/)

you can start hacking!

### Install

```shell
make install
```

and the entire umbrella chart is deployed. This also takes care of creating the `operators` and `data` namespaces. If
you want to install to other namespaces, you need to either edit or override the settings in both the 
[Makefile](Makefile) and [charts/argo/values.yaml](charts/argo/values.yaml).

### Uninstall

```shell
make uninstall
```

This will not delete the `operators` and `data` namespaces, in case you started deploying other stuff there as well.
Also: the data volume for PostgreSQL is kept, so the Workflow archive is still present. It does, however, delete the
MinIO bucket data.

### Update
Once you have deployed and want to tweak the deployment settings, you can update the release using 

```shell
make update
```

## What?

This helm chart currently defaults to the following:

- [X] A local dev-configuration for [Argo CD](https://argoproj.github.io/cd/), deployed in the `operators` namespace by
  default.
- [X] A local dev-configuration for [MinIO](https://min.io/), deployed in the `operators` namespace by default. This
  takes care of local bucket access, so you don't need AWS or GCS storage.
- [X] [PostgresSQL](https://www.postgresql.org/) database, that serves as workflow archive. NOTE that this database is
  NOT backed up on any bucket- or other storage!
- [X] [Argo Workflows](https://argoproj.github.io/workflows/) deployment in the `operators` namespace by default. It is
  able to deploy workflows in the `data` namespace. It writes logs in the MinIO `argo` bucket, and writes completed
  workflow archives to the PostgreSQL database.
- [X] [Argo Events](https://argoproj.github.io/events/) deployment in the `operators` namespace by default. It is 
  able to manage events in the `data` namespace.

### TODO

- [ ] Argo event bus
- [ ] Easy reconfigurable support for installing into namespaces other than `operators` and `data`.
- [ ] Easily configurable way to keep MinIO persistent volumes after uninstall. Something to do with the deletion policy
  of the PV(C).
