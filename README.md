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

## Study Guide

### Kubernetes basics

Kubernetes is a container orchestration system. It runs containers across one or more machines and keeps the desired state you describe in YAML files.

Important concepts:

- **Cluster**: the full Kubernetes environment.
- **Node**: a machine in the cluster. It can be a VM, a physical server, or a container in local tools like k3d.
- **Control plane**: the brain of the cluster. It stores cluster state and schedules workloads.
- **Worker node**: runs application containers.
- **Pod**: the smallest deployable unit in Kubernetes. A pod usually runs one application container.
- **Deployment**: manages pod replicas and rolling updates.
- **Service**: gives pods a stable network name and IP inside the cluster.
- **Ingress**: routes HTTP traffic from outside the cluster to services inside the cluster.
- **Namespace**: separates resources inside the same cluster.
- **kubectl**: the command-line tool used to talk to Kubernetes.

Useful commands:

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc
kubectl get ingress
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl apply -f <file.yaml>
kubectl delete -f <file.yaml>
```

### What is K3s?

K3s is a lightweight Kubernetes distribution made by Rancher. It is still Kubernetes, but packaged to be smaller and easier to run on VMs, edge devices, CI environments, and learning projects.

This repository uses K3s in:

- `p1`: one K3s server VM and one K3s agent VM.
- `p2`: one K3s server VM running three sample apps.

Note: if you wrote `k2s`, you probably mean `K3s`. This project does not use a tool named `k2s`.

### What is k3d?

k3d is a tool that runs K3s clusters inside Docker containers. It is useful when you want a local Kubernetes cluster quickly without creating full VMs.

This repository uses k3d in `p3`:

- Docker runs the local cluster containers.
- k3d creates the Kubernetes cluster.
- Argo CD watches the GitHub repository.
- Argo CD applies the manifests from `p3/confs`.

### K3s vs k3d

| Tool | What it is | Used in this repo |
| --- | --- | --- |
| K3s | Lightweight Kubernetes distribution | `p1`, `p2` |
| k3d | Runs K3s inside Docker containers | `p3` |
| kubectl | CLI for Kubernetes | `p1`, `p2`, `p3` |
| Argo CD | GitOps deployment tool | `p3` |

### GitOps basics

GitOps means Git is the source of truth for the cluster. Instead of manually changing the cluster, you change YAML files, commit them, and let a tool apply them.

In this project:

1. You edit files in `p3/confs`.
2. You commit and push to GitHub.
3. Argo CD detects the change.
4. Argo CD syncs the cluster to match Git.

### Useful resources

- Kubernetes basics: https://kubernetes.io/docs/tutorials/kubernetes-basics/
- Kubernetes concepts: https://kubernetes.io/docs/concepts/
- kubectl cheat sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- K3s documentation: https://docs.k3s.io/
- k3d documentation: https://k3d.io/
- Argo CD documentation: https://argo-cd.readthedocs.io/
- Ingress concept: https://kubernetes.io/docs/concepts/services-networking/ingress/
