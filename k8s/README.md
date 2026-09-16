# Kubernetes — Local Deployment (VLE-5)

Kubernetes is demonstrated on a **local single-node Minikube cluster**
(Docker driver, running on Docker Desktop on the Windows workstation), not
on GitHub Actions. A GitHub-hosted runner is a short-lived, disposable VM
with no network path to a workstation's local Minikube cluster, so
automatically `kubectl apply`-ing from CI here would either fail or
silently do nothing — this project does not pretend otherwise.

**What is automated:** GitHub Actions (`.github/workflows/cicd.yml`) builds
the Docker image, smoke-tests it, and pushes it to GHCR on every push to
`main`.

**What is demonstrated locally, manually, in this experiment:** the
Kubernetes deployment below.

## Making the image available to Minikube

`devops-lab-app` is a locally-built image, not automatically visible to
Minikube's own container runtime. Two options exist; this project uses the
first for simplicity/speed and documents the second as the CI-aligned
alternative:

1. **`minikube image load`** (used here) — builds the image once with the
   host's Docker Desktop, then copies it straight into Minikube's internal
   image store:
   ```bash
   docker build -t devops-lab-app:1.0 ./app
   minikube image load devops-lab-app:1.0
   ```
   `k8s/deployment.yml` references `devops-lab-app:1.0` with
   `imagePullPolicy: IfNotPresent`, so the kubelet uses the pre-loaded
   image instead of trying (and failing) to pull it from Docker Hub.

2. **Pull from GHCR** (what CI publishes) — once GitHub Actions has pushed
   an image, the same manifest can instead reference
   `ghcr.io/<owner>/devops-lab-app:<tag>` with `imagePullPolicy: Always`,
   and Minikube will pull it directly from the registry (needs
   `docker login ghcr.io` / an `imagePullSecret` for a private package).

## Deploy

```bash
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
kubectl rollout status deployment/devops-app
```

## Verify

```bash
kubectl get deployments
kubectl get pods -o wide
kubectl get services
kubectl describe deployment devops-app
kubectl describe pods -l app=devops-app
```

## Access the app

The Docker driver on Windows does not expose the Minikube node IP directly
to the host, so use either:

```bash
kubectl port-forward svc/devops-service 8090:80   # then open http://localhost:8090
# or
minikube service devops-service                   # opens a browser tab via a tunnel
```

## Scaling

```bash
kubectl scale deployment devops-app --replicas=3
kubectl get pods                                   # 3 Running pods
kubectl scale deployment devops-app --replicas=2   # scale back down
kubectl get pods                                   # back to 2 Running pods
```
