# n8n Provisioner

Deterministic, multi-instance provisioning system for self-hosted n8n.

## What This Is
- Declarative installer for isolated n8n + Postgres stacks
- One Docker Compose project per application
- Idempotent installs and re-runnable deployments
- Automatic manifest generation per install

## What This Is Not
- Not Kubernetes
- Not a single shared n8n instance
- Not a manual Docker Compose repo

## Directory Structure

- `scaffold/` — Templates used to generate installs
- `installs/` — Generated application instances (ignored by git)
- `scripts/` — Provisioning and lifecycle scripts

## Status
Scaffolding in progress.

