#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# -----------------------------
# create issuer test
# -----------------------------
# -*- coding: utf-8 -*-
set -x

cat <<EOF >credentials-velero.txt
_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
AZURE_TENANT_ID=$AZURE_TENANT_ID
AZURE_CLIENT_ID=$AZURE_CLIENT_ID
AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET
AZURE_RESOURCE_GROUP=$AZ_RESOURCE_GROUP
AZURE_CLOUD_NAME=AzurePublicCloud
EOF

set +x
