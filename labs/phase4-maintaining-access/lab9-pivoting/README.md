# Lab 9: Lateral Movement & Pivoting

**Phase:** 4 — Maintaining Access
**Tools:** SSH tunneling (`-D`/`-L`), proxychains4, Metasploit, nmap through a proxy

## Overview

Real networks are segmented — the host you land on first is rarely the one holding what you actually want. This lab teaches pivoting: using a compromised host as a relay to reach an internal network your attacker machine can't touch directly.

## Network Map

| Container | Networks | Role |
|-----------|----------|------|
| `lab9-attacker` | external (10.10.9.2) | Metasploit-equipped attacker — external network only |
| `lab9-pivot` | external (10.10.9.10) + internal (10.10.90.10) | The hop — your only path to the internal network |
| `lab9-internal-web` | internal (10.10.90.20) | Only reachable via the pivot |
| `lab9-internal-db` | internal (10.10.90.21) | Only reachable via the pivot |

The internal network (`10.10.90.0/24`) is a Docker `internal: true` network — it has no route out at all except through the pivot host. This isn't simulated; it's actually unreachable any other way.

## Quick Start

```bash
cd labs/phase4-maintaining-access/lab9-pivoting
docker compose up -d
docker exec -it lab9-attacker bash
ping -c 2 10.10.9.10          # pivot — reachable
ping -c 2 10.10.90.20         # internal target — will NOT respond yet
```

## Credentials

- Pivot host SSH: `pivotuser` / `pivot123`

## Cleanup

```bash
docker compose down
```
