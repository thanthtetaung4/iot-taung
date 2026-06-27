#!/usr/bin/env bash
set -euo pipefail

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Wait for node and Traefik/cluster services to become usable.
kubectl wait --for=condition=Ready node --all --timeout=180s || true
kubectl apply -f /vagrant/confs/app1.yaml
kubectl apply -f /vagrant/confs/app2.yaml
kubectl apply -f /vagrant/confs/app3.yaml
kubectl apply -f /vagrant/confs/ingress.yaml

kubectl get all
kubectl get ingress
