# argo-batteries-included

An umbrella helm chart for a local dev/test setup the Argo ecosystem, with batteries included. This allows you to freely
experiment and muck around without requiring access to a full cloud cluster. All applications work out of the box and
pointers to how to log into dev consoles is provided by the installation notes itself.

## What?

This helm chart currently contains the following:
- [X] A local dev-configuration for ArgoCD
- [X] A local dev-configuration for Minio. This takes care of local bucket access so you don't need AWS or GCS storage.
- [X] PostgresSQL workflow archive database. NOTE that this database is NOT backed up on any bucket- or other storage!

### TODO

- [ ] Argo Workflows
- [ ] Argo Events
- [ ] Argo event bus

## Why?

The Argo ecosystem is an incredibly useful set of tools for managing workflows, events and releases. However, the 
default settings for the Argo Helm charts leave a bit of configuration to set in order to get a working development or
production environment. This Helm chart is intended to help you set up Argo components, with batteries included.

## How?
For now, I've decided to run with a simple Makefile approach, which keeps things extremely simple. 

### Install

For example, use with a [k3s](https://k3s.io/) development environment:
```shell
make install
```

### Uninstall
```shell
make uninstall
```