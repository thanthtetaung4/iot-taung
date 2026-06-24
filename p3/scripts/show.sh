#!/usr/bin/env bash
set -euo pipefail

echo "Namespaces:"
kubectl get ns

echo "\nArgo CD pods:"
kubectl get pods -n argocd

echo "\nDev pods/services:"
kubectl get pods,svc -n dev

echo "\nArgo CD applications:"
kubectl get applications -n argocd || true

echo "\nTest app:"
curl -s http://localhost:8888/ || true
echo
