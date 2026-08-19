# Lab 4: Web Enumeration

**Phase:** 2 — Scanning & Enumeration
**Tools:** gobuster, dirb, ffuf, nikto

## Overview

A web server's homepage rarely shows everything that's actually deployed on it. This lab practices finding what's *not* linked — hidden directories, backup files, admin panels — using directory/file brute-forcing tools, plus `nikto` for automated misconfiguration checks.

## Network Map

Subnet: `10.10.4.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab4-attacker` | 10.10.4.2 | Kali attacker |
| `lab4-web` | 10.10.4.10 | Nginx web server with undisclosed paths |

## Quick Start

```bash
cd labs/phase2-scanning-enumeration/lab4-web-enumeration
docker compose up -d
docker exec -it lab4-attacker bash
```

## Cleanup

```bash
docker compose down
```
