# Inception of Things

This repository contains the three IoT project parts:

- `p1`: two Vagrant VMs running K3s in server/agent mode.
- `p2`: one Vagrant VM running K3s with three web apps exposed through Ingress.
- `p3`: k3d, Argo CD, and GitHub-based GitOps deployment.

## Requirements

- VirtualBox and Vagrant for `p1` and `p2`.
- Docker for `p3`.
- Internet access during provisioning, because the scripts download K3s, Docker, kubectl, k3d, and Argo CD components.

## Part 1

```bash
cd p1
vagrant up
vagrant ssh taungS
kubectl get nodes -o wide
```

Expected: `taungS` and `taungSW` are both `Ready`.

## Part 2

```bash
cd p2
vagrant up
vagrant ssh taungS
kubectl get pods,svc,ingress
```

Test from the host:

```bash
curl -H "Host: app1.com" http://192.168.56.110
curl -H "Host: app2.com" http://192.168.56.110
curl -H "Host: random.com" http://192.168.56.110
```

Expected responses:

```text
Hello from app1
Hello from app2
Hello from app3 default
```

## Part 3

Part 3 uses k3d to run a local Kubernetes cluster and Argo CD to sync the manifests in `p3/confs` from this GitHub repository.

Before running, check `p3/confs/application.yaml`:

- `repoURL` should point to this public repository.
- `targetRevision` is `master`.
- `path` is `p3/confs`.

Run:

```bash
chmod +x p3/scripts/*.sh
./p3/scripts/install.sh
```

If Docker permissions are not active yet, refresh the shell group:

```bash
newgrp docker
```

Then continue:

```bash
./p3/scripts/setup.sh
kubectl apply -f p3/confs/application.yaml
./p3/scripts/show.sh
```

The application is exposed on the host at:

```bash
curl http://localhost:8888/
```

The current deployment image is `wil42/playground:v2`, so the expected response is:

```json
{"status":"ok", "message":"v2"}
```

## Argo CD UI

To view Argo CD:

```bash
./p3/scripts/argocd-ui.sh
```

Then open:

```text
https://localhost:8080
```

Username is `admin`. The script prints the initial password.

## GitOps Demo

To demonstrate Argo CD sync, change the image tag in `p3/confs/deployment.yaml`, commit, and push:

```yaml
image: wil42/playground:v1
```

```bash
git add p3/confs/deployment.yaml
git commit -m "Deploy v1"
git push origin master
```

Argo CD automatically syncs the change. Check it with:

```bash
curl http://localhost:8888/
```
