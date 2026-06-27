#!/usr/bin/env bash
set -euo pipefail

# Wait until the server creates the join token.
while [ ! -f /vagrant/node-token ]; do
  echo "Waiting for K3s server token..."
  sleep 3
done

TOKEN=$(cat /vagrant/node-token)
export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN="$TOKEN"
export INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111"

curl -sfL https://get.k3s.io | sh -
