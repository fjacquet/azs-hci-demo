#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x
#-----------------------------------------------------------------------------
####  DNS area
#-----------------------------------------------------------------------------

az network dns zone create \
  --resource-group ${AZ_RESOURCE_GROUP} \
  --name ${AZ_DNS_DOMAIN}

az network dns zone list \
  --query "[?name=='$AZ_DNS_DOMAIN']" --output table

#-----------------------------------------------------------------------------
# Fetch DNS Scope, e.g.
#  /subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$AZ_RESOURCE_GROUP/providers/Microsoft.Network/dnszones/$AZ_AZ_DNS_DOMAIN/
#-----------------------------------------------------------------------------
export AZ_DNS_SCOPE=$(
  az network dns zone list \
    --query "[?name=='$AZ_DNS_DOMAIN'].id" \
    --output table | tail -1
)

#-----------------------------------------------------------------------------
# Fetch Kubelet identity, i.e. managed identity assigned to node pools managed by VMSS
#-----------------------------------------------------------------------------
export AZ_PRINCIPAL_ID=$(
  az aks show -g $AZ_RESOURCE_GROUP -n $AKS_CLUSTER_NAME \
    --query "identityProfile.kubeletidentity.objectId" \
    --output tsv
)

#-----------------------------------------------------------------------------
# Assign role to kubelet identity that allows ALL pods to update DNS records
#-----------------------------------------------------------------------------
az role assignment create \
  --assignee $AZ_PRINCIPAL_ID \
  --role "DNS Zone Contributor" \
  --scope "$AZ_DNS_SCOPE"

#-----------------------------------------------------------------------------
# show role bindings on kublet id (managed id assigned to VMSS node pool)
#-----------------------------------------------------------------------------
echo "check AKS role assignment"
az role assignment list --assignee $AZ_PRINCIPAL_ID --all \
  --query '[].{roleDefinitionName:roleDefinitionName, provider:scope}' \
  --output table | sed 's|/subscriptions.*providers/||' | cut -c -80

#-----------------------------------------------------------------------------
# create namespace
#-----------------------------------------------------------------------------
echo "check namespace $NAMESPACE_KUBEADDONS"
kubectl create namespace $NAMESPACE_KUBEADDONS 2>/dev/null

#-----------------------------------------------------------------------------
# Generate file
#-----------------------------------------------------------------------------
cat <<-EOF >helmfile.yaml

releases:
  - name: external-dns
    namespace: $NAMESPACE_KUBEADDONS
    chart: bitnami/external-dns
    # version: 5.1.1
    values:
      - provider: azure
        azure:
          resourceGroup: $AZ_RESOURCE_GROUP
          tenantId: $AZ_TENANT_ID
          subscriptionId: $AZ_SUBSCRIPTION_ID
          useManagedIdentityExtension: true
        logLevel: $EXTERNALDNS_LOG_LEVEL
        domainFilters:
          - $AZ_DNS_DOMAIN
        txtOwnerId: external-dns
EOF

#-----------------------------------------------------------------------------
# Apply and cleanup
#-----------------------------------------------------------------------------
helmfile apply
rm helmfile.yaml
#-----------------------------------------------------------------------------
# get DNS secret
#-----------------------------------------------------------------------------
kubectl get secret external-dns \
  --namespace $NAMESPACE_KUBEADDONS \
  --output jsonpath="{.data.azure\.json}" | base64 --decode

#-----------------------------------------------------------------------------
# Testing
#-----------------------------------------------------------------------------
LABEL_NAME="app.kubernetes.io/name=external-dns"
LABEL_INSTANCE="app.kubernetes.io/instance=external-dns"

EXTERNAL_DNS_POD_NAME=$(
  kubectl \
    --namespace $NAMESPACE_KUBEADDONS get pods \
    --selector "$LABEL_NAME,$LABEL_INSTANCE" \
    --output name
)

kubectl logs --namespace $NAMESPACE_KUBEADDONS $EXTERNAL_DNS_POD_NAME
set +x
