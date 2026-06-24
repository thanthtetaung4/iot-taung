#!/usr/bin/env bash
set -euo pipefail

echo "Argo CD username: admin"
echo -n "Argo CD password: "
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
echo

echo "Opening Argo CD UI at https://localhost:8080"
echo "Keep this terminal running."
kubectl port-forward svc/argocd-server -n argocd 8080:443
