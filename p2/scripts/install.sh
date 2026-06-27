#!/usr/bin/env bash
set -euo pipefail

export INSTALL_K3S_EXEC="server --node-ip=192.168.56.110 --advertise-address=192.168.56.110 --write-kubeconfig-mode=644"
curl -sfL https://get.k3s.io | sh -

mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >/etc/profile.d/k3s.sh
