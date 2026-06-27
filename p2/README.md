# P2 - K3s and Three Simple Applications

## What this creates

One VM:

- `taungS` at `192.168.56.110`.
- K3s server mode.
- 3 apps:
  - `app1`: 1 replica, returns `Hello from app1`.
  - `app2`: 3 replicas, returns `Hello from app2`.
  - `app3`: default fallback app, returns `Hello from app3 default`.

The Vagrant provisioner installs K3s and then applies all manifests from `p2/confs`.

## Run

```bash
cd p2
vagrant up
vagrant ssh taungS
kubectl get pods,svc,ingress
```

## Test routing

Run these from the host machine:

```bash
curl -H "Host: app1.com" http://192.168.56.110
curl -H "Host: app2.com" http://192.168.56.110
curl -H "Host: random.com" http://192.168.56.110
```

Expected:

```text
Hello from app1
Hello from app2
Hello from app3 default
```

## Notes

- K3s includes Traefik by default, which handles the Ingress.
- `app2` has `replicas: 3`, as required.
- Requests for `app1.com` route to `app1`.
- Requests for `app2.com` route to `app2`.
- Requests with any other host route to the default `app3` backend.

## Stop / clean

```bash
vagrant halt
vagrant destroy -f
```
