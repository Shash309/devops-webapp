# Ansible — Configuration Management (VLE-5)

Ansible's job here is narrow and specific: **configure the two VLE-4 EC2
instances with Docker**, so they can run the containerized application this
experiment builds. It is *not* used to install Kubernetes and it does not
touch the local Windows workstation.

- [`setup.yml`](setup.yml) — idempotent playbook (same one used for VLE-4)
  that installs Docker, starts and enables the service, and adds `ec2-user`
  to the `docker` group. Safe to re-run: it uses module `state:`, not raw
  shell commands, so re-running makes no changes once Docker is already
  installed.
- [`inventory.ini.example`](inventory.ini.example) — template inventory.
  The real `inventory.ini` is generated from `terraform output` (the EC2
  public IPs change every time VLE-4 is re-applied) and is **gitignored**
  because it captures environment-specific infrastructure detail.
- [`ansible.cfg`](ansible.cfg) — points at `./inventory.ini` and disables
  host-key prompts for the lab's short-lived EC2 hosts.

## Why Ansible is not used for the local Kubernetes step

Kubernetes in this experiment runs locally via **Minikube on the Windows
workstation** (see [`../k8s`](../k8s)). Minikube manages its own
single-node cluster lifecycle (`minikube start`/`stop`); there is no
separate "server" for Ansible to configure, and Minikube itself is not
installed via Ansible. Ansible's role stays where it adds real value:
repeatable server configuration for the EC2 tier.

## Usage

```bash
cd ansible
cp inventory.ini.example inventory.ini   # fill in real EC2 public IPs
ansible servers -m ping
ansible-playbook setup.yml
```

Requires the AWS Academy EC2 instances to be running and the SSH key
(`~/.ssh/labsuser.pem`) and current security-group `ssh_allowed_cidr` to be
in place (see [`../terraform`](../terraform)).
