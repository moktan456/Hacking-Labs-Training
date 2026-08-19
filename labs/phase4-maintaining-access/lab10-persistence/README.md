# Lab 10: Persistence & Backdoors

**Phase:** 4 — Maintaining Access
**Tools:** ssh-keygen, cron, netcat, socat

## Overview

Getting in once isn't the job — real engagements (and real attackers) need access that survives a password rotation, a reboot, or the original vulnerability being patched. This lab starts with a foothold already given, and has you plant three different persistence mechanisms, then prove they work by rotating the target's credentials yourself and getting back in anyway.

## Network Map

Subnet: `10.10.10.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab10-attacker` | 10.10.10.2 | Kali attacker |
| `lab10-target` | 10.10.10.10 | SSH target — foothold given, cron and netcat/socat available |

## Quick Start

```bash
cd labs/phase4-maintaining-access/lab10-persistence
docker compose up -d
docker exec -it lab10-attacker bash
```

## Credentials (your starting foothold)

- SSH: `lowpriv` / `lowpriv123`

## Cleanup

```bash
docker compose down
```
