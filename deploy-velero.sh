#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
helm install velero vmware-tanzu/velero \ --version 2.32.3 \
  --set-file credentials.secretContents.cloud= PATH TO FILE \
  configuration.provider= NAME \
  configuration.backupStorageLocation.name= STORAGE LOCATION NAME \
  configuration.backupStorageLocation.bucket= NAME \
  configuration.backupStorageLocation.config.region= \
  configuration.volumeSnapshotLocation.name= SNAPSHOT LOCATION NAME \
  configuration.volumeSnapshotLocation.config.region= \
  initContainers[0].name=velero-plugin-for- NAME \
  initContainers[0].image=velero/velero-plugin-for- NAME PLUGIN TAG \
  initContainers[0].volumeMounts[0].mountPath=/target \
  --set initContainers[0].volumeMounts[0].name=plugins <FULL > \
  --set <PROVIDER > \
  --set <BACKUP > \
  --set <BUCKET > \
  --set <REGION > \
  --set <VOLUME > \
  --set <REGION > \
  --set <PROVIDER > \
  --set <PROVIDER >: <PROVIDER > \
  --set

# kubectl create secret tls mysecretname --key mycert.key --cert mycert.crt
set +x
