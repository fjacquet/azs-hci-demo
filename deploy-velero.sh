#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
ACCESS=$(date +%Y%m%d)
AZURE_BACKUP_RESOURCE_GROUP=$AZ_RESOURCE_GROUP
AZURE_BACKUP_SUBSCRIPTION_NAME="Azure subscription 1"
AZURE_BACKUP_SUBSCRIPTION_ID=$(az account list --query="[?name=='$AZURE_BACKUP_SUBSCRIPTION_NAME'].id | [0]" -o tsv)
AZURE_STORAGE_ACCOUNT_ID="aksbackup2$ACCESS"
AZURE_SUBSCRIPTION_ID=$(az account list --query '[?isDefault].id' -o tsv)
AZURE_TENANT_ID=$(az account list --query '[?isDefault].tenantId' -o tsv)
BLOB_CONTAINER="velero"

#-----------------------------------------------------------------------------
#### Create the blob
#-----------------------------------------------------------------------------
az storage account create \
  --name $AZURE_STORAGE_ACCOUNT_ID \
  --resource-group $AZ_RESOURCE_GROUP \
  --sku Standard_GRS \
  --encryption-services blob \
  --https-only true \
  --kind BlobStorage \
  --access-tier Hot

az storage container create \
  -n $BLOB_CONTAINER \
  --public-access off \
  --account-name $AZURE_STORAGE_ACCOUNT_ID

#-----------------------------------------------------------------------------
#### Create the service principal
#-----------------------------------------------------------------------------

AZURE_CLIENT_SECRET=$(az ad sp create-for-rbac --name "velero" --role "Contributor" --query 'password' -o tsv --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID)
AZURE_CLIENT_ID=$(az ad sp list --display-name "velero" --query '[0].appId' -o tsv)

. ./generate-velero-secret.sh

velero install --provider azure \
  --plugins velero/velero-plugin-for-microsoft-azure:v1.5.0 \
  --bucket $BLOB_CONTAINER \
  --secret-file credentials-velero.txt \
  --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_STORAGE_ACCOUNT_ID,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID \
  --use-restic

rm credentials-velero.txt

velero backup create alfred --default-volumes-to-restic

# kubectl create secret tls mysecretname --key mycert.key --cert mycert.crt
set +x
