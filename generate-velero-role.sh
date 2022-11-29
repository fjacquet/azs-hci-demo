#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# -----------------------------
# create issuer test
# -----------------------------
cat <<EOF >velero-role.json
{
  "Name": "velero-backup-role",
  "Id": null,
  "IsCustom": true,
  "Description": "Velero related permissions to perform backups, restores and deletions",
  "Actions": [
    "Microsoft.Compute/disks/read",
    "Microsoft.Compute/disks/write",
    "Microsoft.Compute/disks/endGetAccess/action",
    "Microsoft.Compute/disks/beginGetAccess/action",
    "Microsoft.Compute/snapshots/read",
    "Microsoft.Compute/snapshots/write",
    "Microsoft.Compute/snapshots/delete",
    "Microsoft.Storage/storageAccounts/listkeys/action",
    "Microsoft.Storage/storageAccounts/regeneratekey/action"
  ],
  "NotActions": [],
  "AssignableScopes": [ "/subscriptions/$AZ_SUBSCRIPTION_ID" ]
}
EOF
