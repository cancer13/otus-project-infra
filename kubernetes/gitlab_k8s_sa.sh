#!/bin/bash
kubectl apply -f gitlab-admin-service-account.yaml
kubectl -n kube-system get secrets -o json | \
jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | \
base64 --decode
