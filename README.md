# Argo: batteries included

This repo contains an "educational" helm chart, useful for exploration, local development and testing. Applications like
Argo Workflows can be quite tricky to set up, so once you have a working local system, it becomes easier to experiment
with, and adapt it to your liking and production environment requirements so that it offers a clear migration path. 

The purpose of this repo is to provide an "umbrella helm chart" for a local dev/test setup of the Argo ecosystem, with
batteries included. This allows you to freely experiment and muck around without requiring access to a full cloud
cluster. All applications work out of the box. Hints on application logins is provided by the installation notes itself.

NOTE: Do not use this chart as is for ANY kind of production environment!

For details on what applications are deployed with this chart, see [What](#what).

## Why?

The Argo ecosystem is an incredibly useful set of tools for managing workflows, events and releases. However:

1. The default settings for the Argo Helm charts leave a bit of configuration to set in order to get a working
   development environment. This Helm chart is intended to help you set up full-featured Argo components, with batteries
   included.
2. Also: this chart is targeted specifically at local "bare metal" or minimal development or testing installation
   environments, rather than full-scale large cloud clusters. Once you reach _that_ stage, you have probably (re-)visited
   every [configuration setting](charts/argo/values.yaml) that this chart provides as a "getting started" resource.

## How?

For now, I've decided to run with a simple Makefile approach, which keeps things extremely simple. After
installing 
- [k3s](https://rancher.com/docs/k3s/latest/en/installation/) (tested)
  or [minikube](https://minikube.sigs.k8s.io/docs/start/) (untested),
- and [Helm](https://helm.sh/docs/intro/install/)

you can start hacking!

### Install

```shell
make install
```

and the entire umbrella chart is deployed. If you want to install to other namespaces, you need to either edit or
override the settings in both the [Makefile](Makefile) and [charts/argo/values.yaml](charts/argo/values.yaml).

### Uninstall

```shell
make uninstall
```

### Update
Once you have deployed and want to tweak the deployment settings, you can update the release using 

```shell
make update
```

## What?

This helm chart currently offers the following:

- [X] A convenience [`Makefile`](Makefile) that provides a single `make install` command to deploy the entire release.
  It also takes care of creating the `operators` and `data` namespaces.
- [X] A local dev-configuration for [Argo-CD](https://argoproj.github.io/cd/), deployed in the `operators` namespace by
  default.
- [X] A local dev-configuration for [MinIO](https://min.io/), deployed in the `operators` namespace by default. This
  takes care of local bucket access, so you don't need AWS or GCS storage.
- [X] [PostgresSQL](https://www.postgresql.org/) database, that serves as workflow archive. NOTE that this database is
  NOT backed up on any bucket- or other storage!
- [X] Argo Workflows deployment in `operators` by default, but that is able to deploy workflows in the `data` namespace.
  It writes logs in the Minio `argo` bucket, and writes completed workflow archives to the PostgreSQL database. 

### TODO

- [ ] Argo Events
- [ ] Argo event bus
- [ ] Easy reconfigurable support for installing into namespaces other than `operators` and `data`.
