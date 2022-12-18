#!/usr/bin/env bash
# -*- coding: utf-8 -*-
set -x

# Generate cluster
eksctl create cluster \
  -f cluster.yaml

# Create access
eksctl get iamidentitymapping \
  --cluster $CLUSTER \
  --region=$REGION

eksctl create iamidentitymapping \
  --cluster $CLUSTER \
  --region $REGION \
  --arn arn:aws:iam::$IAM\:role/my-console-viewer-role \
  --group eks-console-dashboard-full-access-group \
  --no-duplicate-arns

eksctl create iamidentitymapping \
  --cluster $CLUSTER \
  --region $REGION \
  --arn arn:aws:iam::$IAM\:user/my-user \
  --group eks-console-dashboard-restricted-access-group \
  --no-duplicate-arns

eksctl get iamidentitymapping \
  --cluster $CLUSTER \
  --region $REGION

kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml

# Create nginx
kubectl get nodes --label-columns=kubernetes.io/arch
kubectl apply -f nginx.yaml
kubectl get pod -o wide

set +x
