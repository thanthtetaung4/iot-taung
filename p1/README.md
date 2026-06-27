# P1 - K3s With Vagrant

## What this creates

- `taungS` at `192.168.56.110`: K3s server/control-plane.
- `taungSW` at `192.168.56.111`: K3s agent/worker.

Both machines use the `bento/ubuntu-24.04` Vagrant box and VirtualBox provider.

The server writes its K3s node token to `/vagrant/node-token`. The worker waits for that token and then joins the server at `https://192.168.56.110:6443`.

## Run

```bash
cd p1
vagrant up
vagrant ssh taungS
kubectl get nodes -o wide
```

Expected: both `taungS` and `taungSW` should be `Ready`.

## Useful checks

From the server VM:

```bash
kubectl get nodes
kubectl get pods -A
```

The kubeconfig is available at:

```text
/etc/rancher/k3s/k3s.yaml
```

## Stop / clean

```bash
vagrant halt
vagrant destroy -f
rm -f node-token
```
