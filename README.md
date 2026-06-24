# Inception of Things - Part 3 Template

This template implements Part 3: K3d + Argo CD + GitHub GitOps.

## Usage

1. Put this folder in your project repository.
2. Create a public GitHub repository. Its name should include your login/name.
3. Edit `p3/confs/application.yaml`:
   - replace `repoURL`
   - use `master` or change to `main` if your repo uses main
4. Push everything to GitHub.
5. On your VM, run:

```bash
chmod +x p3/scripts/*.sh
./p3/scripts/install.sh
newgrp docker
./p3/scripts/setup.sh
kubectl apply -f p3/confs/application.yaml
./p3/scripts/show.sh
```

## Demonstration

Initial version:

```bash
curl http://localhost:8888/
```

Expected:

```json
{"status":"ok", "message":"v1"}
```

Then change `p3/confs/deployment.yaml`:

```yaml
image: wil42/playground:v2
```

Commit and push:

```bash
git add p3/confs/deployment.yaml
git commit -m "Deploy v2"
git push origin master
```

Wait for Argo CD sync, then:

```bash
curl http://localhost:8888/
```

Expected:

```json
{"status":"ok", "message":"v2"}
```
