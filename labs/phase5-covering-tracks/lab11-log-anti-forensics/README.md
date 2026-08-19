# Lab 11: Log Manipulation & Anti-Forensics

**Phase:** 5 — Covering Tracks
**Tools:** bash history controls, log editing, `touch` timestomping, `shred`

## Overview

The fifth phase isn't about getting in or staying in — it's about not leaving a trail once you were there. This lab has you generate realistic evidence of your activity (login records, command history, a dropped file) and then remove or falsify each piece, verified by an included checker script.

## Network Map

Subnet: `10.10.11.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab11-attacker` | 10.10.11.2 | Kali attacker |
| `lab11-target` | 10.10.11.10 | SSH target — root access given, rsyslog running |

## Quick Start

```bash
cd labs/phase5-covering-tracks/lab11-log-anti-forensics
docker compose up -d
docker exec -it lab11-attacker bash
```

## Credentials

- SSH: `root` / `toor123`

## Cleanup

```bash
docker compose down
```
