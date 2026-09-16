# devops-webapp

This repository holds two Virtual Lab Experiments built incrementally on
the same simple web app:

- **VLE-3 — End-to-end automation using Git**: the original static site at
  the repo root (`index.html`, `style.css`, `script.js`) with a validation
  + Slack-notification workflow at [`.github/workflows/ci.yml`](.github/workflows/ci.yml).
- **VLE-5 — End-to-End DevOps CI/CD Pipeline** (this experiment): a
  containerized version of the app, deployed through a full
  Git → GitHub Actions → Docker → Kubernetes pipeline.

## VLE-5 layout

```
app/            NGINX-served HTML app + Dockerfile
terraform/      Infrastructure provisioning (reuses the VLE-4 VPC/EC2 config)
ansible/        Docker installation on the VLE-4 EC2 instances
k8s/            Deployment + Service manifests for local Minikube
.github/workflows/cicd.yml   CI: build, smoke-test, push image to GHCR
```

## Architecture

```
Developer pushes to app/**
        |
        v
GitHub Actions (cicd.yml)
   - checkout
   - validate app files
   - docker build
   - docker run + curl smoke test
   - push image -> ghcr.io/<owner>/devops-lab-app
        |
        v
   (automated CI/CD boundary)
        |
        v
Local Minikube cluster (developer workstation)
   - minikube image load devops-lab-app:1.0
   - kubectl apply -f k8s/deployment.yml   (2 replicas)
   - kubectl apply -f k8s/service.yml      (NodePort)
   - kubectl scale deployment devops-app --replicas=3   (scaling demo)
```

**GitHub Actions builds, tests and publishes the image. It does not deploy
to Kubernetes.** A GitHub-hosted runner has no network route to a Minikube
cluster running on a personal workstation, so the Kubernetes step is
demonstrated locally and documented with real command output rather than
faked as an automated step. See [`k8s/README.md`](k8s/README.md),
[`terraform/README.md`](terraform/README.md) and
[`ansible/README.md`](ansible/README.md) for what each tool is actually
responsible for.

Full write-up, screenshots checklist and viva prep:
`VLE-5_End-to-End_DevOps_CICD_Report` (submitted separately).
