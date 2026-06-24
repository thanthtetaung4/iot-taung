#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="iot"
ARGO_NS="argocd"
DEV_NS="dev"

# Create k3d cluster. Port 8888 on localhost maps to service port 8888 in the cluster.
if ! k3d cluster list | grep -q "^${CLUSTER_NAME}"; then
  k3d cluster create "$CLUSTER_NAME" --servers 1 --agents 1 -p "8888:8888@loadbalancer"
fi

kubectl create namespace "$ARGO_NS" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$DEV_NS" --dry-run=client -o yaml | kubectl apply -f -

# Install Argo CD
kubectl apply -n "$ARGO_NS" -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n "$ARGO_NS"
kubectl wait --for=condition=available --timeout=300s deployment/argocd-repo-server -n "$ARGO_NS"
kubectl wait --for=condition=available --timeout=300s deployment/argocd-application-controller -n "$ARGO_NS" || true

echo "Cluster ready."
echo "Next: edit p3/confs/application.yaml and replace repoURL with your public GitHub repository."
echo "Then run: kubectl apply -f p3/confs/application.yaml"
