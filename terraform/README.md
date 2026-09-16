# Terraform — Infrastructure Provisioning (VLE-5)

This configuration **is the same VLE-4 Terraform project**, carried into this
repository rather than re-written from scratch, because VLE-4 already
provisions everything a VLE-5 "server tier" would need:

- 1 VPC with a public subnet, Internet Gateway and route table
- 1 security group (SSH restricted to the operator's IP, HTTP open)
- 2 EC2 instances (Amazon Linux 2023, resolved dynamically via SSM — no
  stale hard-coded AMI ID) with Docker installed by the companion Ansible
  playbook in [`../ansible`](../ansible)

**Why it is not re-applied here:** the VLE-4 instances were already live
during this experiment (see the report's Evidence section for `terraform
state list` / `aws ec2 describe-instances` output). Running `terraform
apply` again from a second copy of the same config against the same AWS
Academy account would either duplicate billable EC2 instances or fight the
original state file for the same resources. Provisioning is demonstrated
here with `terraform fmt`, `init`, `validate` and `plan` — the plan shows
Terraform's intended create-set without touching real infrastructure.

**AWS Academy credentials are temporary** (`voclabs` STS session, valid a
few hours per lab session). When they expire, `terraform plan` / `apply`
fails with `ExpiredToken` until the lab session is restarted and
`aws configure` / `~/.aws/credentials` is refreshed — this is expected
and is not a bug in the configuration.

## Usage

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # fill in your own values
terraform init
terraform fmt -check
terraform validate
terraform plan
```

`terraform apply` is intentionally **not** run automatically — infrastructure
changes are reviewed and applied manually after inspecting the plan.
