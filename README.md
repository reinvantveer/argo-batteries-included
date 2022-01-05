# argo-batteries-included

An umbrella helm chart for a local dev/test setup the Argo ecosystem, with batteries included. This allows you to freely
experiment and muck around without requiring access to a full cloud cluster. All applications work out of the box. 
Hints on application logins is provided by the installation notes itself.

## How?

For now, I've decided to run with a simple Makefile approach, which keeps things extremely simple. After
installing [k3s](https://rancher.com/docs/k3s/latest/en/installation/) (tested)
or [minikube](https://minikube.sigs.k8s.io/docs/start/) (untested), just enter

```shell
make install
```

and the entire umbrella chart is deployed. If you want to install to other namespaces, you need to either edit or
override the settings in both the [Makefile](Makefile) and [charts/argo/values.yaml](charts/argo/values.yaml).

### Install

For example, use with a [k3s](https://k3s.io/) development environment:
```shell
make install
```

### Uninstall
```shell
make uninstall
```

## What?

This helm chart currently offers deployment of the following:
- [X] A convenience [`Makefile`](Makefile) that provides a single `make install` command to deploy the entire release. 
- [X] A local dev-configuration for [Argo-CD](https://argoproj.github.io/cd/), deployed in the `operators` namespace by default.
- [X] A local dev-configuration for Minio, deployed in the `operators` namespace. This takes care of local bucket
  access, so you don't need AWS or GCS storage.
- [X] PostgresSQL workflow archive database. NOTE that this database is NOT backed up on any bucket- or other storage!
- [X] Argo Workflows deployment in `operators` by default, but that is able to deploy workflows in the `data` namespace.
  It writes logs in the Minio `argo` bucket, and writes completed workflow archives to the PostgreSQL database. 

### TODO

- [ ] Argo Events
- [ ] Argo event bus
- [ ] Easy reconfigurable support for installing into namespaces other than `operators` and `data`.

## Why?

The Argo ecosystem is an incredibly useful set of tools for managing workflows, events and releases. However, the 
default settings for the Argo Helm charts leave a bit of configuration to set in order to get a working development or
production environment. This Helm chart is intended to help you set up Argo components, with batteries included.

