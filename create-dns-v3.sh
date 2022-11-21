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


# fetch DNS id used to grant access to the kublet identity
DNS_ID=$(az network dns zone show --name $AZ_DNS_DOMAIN \
  --resource-group $AZ_RESOURCE_GROUP --query "id" --output tsv)

az role assignment create --role "DNS Zone Contributor" \
--assignee $AZ_PRINCIPAL_ID \
--scope $DNS_ID

# #-----------------------------------------------------------------------------
# # Assign role to kubelet identity that allows ALL pods to update DNS records
# #-----------------------------------------------------------------------------
# az role assignment create \
#   --assignee $AZ_PRINCIPAL_ID \
#   --role "DNS Zone Contributor" \
#   --scope "$AZ_DNS_SCOPE"

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
cat <<-EOF > azure.json
{
  "tenantId": "$AZ_SUBSCRIPTION_ID",
  "subscriptionId": "$AZ_TENANT_ID",
  "resourceGroup": "$AZ_RESOURCE_GROUP",
  "useManagedIdentityExtension": true
}
EOF
kubectl create secret generic azure-config-file --namespace "default" --from-file azure.json
rm azure.json


#-----------------------------------------------------------------------------
#Manifest (for clusters with RBAC enabled, namespace access)
#-----------------------------------------------------------------------------

cat <<-EOF > externaldns.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
rules:
  - apiGroups: [""]
    resources: ["services","endpoints","pods", "nodes"]
    verbs: ["get","watch","list"]
  - apiGroups: ["extensions","networking.k8s.io"]
    resources: ["ingresses"]
    verbs: ["get","watch","list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
  - kind: ServiceAccount
    name: external-dns
    namespace: default
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      serviceAccountName: external-dns
      containers:
        - name: external-dns
          image: k8s.gcr.io/external-dns/external-dns:v0.11.0
          args:
            - --source=service
            - --source=ingress
            - --domain-filter=$AZ_AZ_DNS_DOMAIN
            - --provider=azure
            - --azure-resource-group=$AZ_RESOURCE_GROUP
            - --txt-prefix=externaldns-
          volumeMounts:
            - name: azure-config-file
              mountPath: /etc/kubernetes
              readOnly: true
      volumes:
        - name: azure-config-file
          secret:
            secretName: azure-config-file
EOF
kubectl create --namespace "default" --filename externaldns.yaml
rm externaldns.yaml


 az network dns record-set a list \
 --resource-group AZ_RESOURCE_GROUP \
 --zone-name $AZ_AZ_DNS_DOMAIN

#-----------------------------------------------------------------------------
# get DNS secret
#-----------------------------------------------------------------------------
# kubectl get secret external-dns \
#   --namespace $NAMESPACE_KUBEADDONS \
#   --output jsonpath="{.data.azure\.json}" | base64 --decode

# #-----------------------------------------------------------------------------
# # Testing
# #-----------------------------------------------------------------------------
# LABEL_NAME="app.kubernetes.io/name=external-dns"
# LABEL_INSTANCE="app.kubernetes.io/instance=external-dns"

# EXTERNAL_DNS_POD_NAME=$(
#   kubectl \
#     --namespace $NAMESPACE_KUBEADDONS get pods \
#     --selector "$LABEL_NAME,$LABEL_INSTANCE" \
#     --output name
# )

# kubectl logs --namespace $NAMESPACE_KUBEADDONS $EXTERNAL_DNS_POD_NAME
set +x
