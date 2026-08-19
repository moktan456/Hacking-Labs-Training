# Lab 3: Nmap Port & Service Scanning

**Phase:** 2 — Scanning & Enumeration
**Tools:** nmap

## Overview

Nmap is the workhorse of active scanning: discovering hosts, finding open ports, fingerprinting exactly what's listening on them, and running scripted checks against known services. This lab walks through the full range — ping sweeps, connect/SYN scans, version detection, aggressive scans, and NSE scripts — against three realistic targets.

## Network Map

Subnet: `10.10.3.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab3-attacker` | 10.10.3.2 | Kali attacker |
| `lab3-web` | 10.10.3.10 | HTTP (Nginx) |
| `lab3-ftp` | 10.10.3.11 | FTP (vsftpd), anonymous access enabled |
| `lab3-ssh` | 10.10.3.12 | SSH (OpenSSH), password auth enabled |

## Quick Start

```bash
cd labs/phase2-scanning-enumeration/lab3-nmap-scanning
docker compose up -d
docker exec -it lab3-attacker bash
```

## Cleanup

```bash
docker compose down
```
