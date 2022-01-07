# Experimental/educational Argo umbrella chart

## What?

This "argo" helm chart currently defaults to the following:

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
- [X] Argo event bus in `operators` and `data` namespaces (Argo Events doesn't do much without it).
