# Lab 12: Full-Chain Capstone CTF

**Phase:** Capstone — all 5 phases, chained
**Tools:** everything from Labs 1–11

## Overview

No hand-holding this time. One target network, three services, and no given credentials. You'll run the entire chain yourself: reconnaissance → enumeration → gaining access → (optionally) maintaining access and covering tracks. This is modeled on the classic De-ICE-style "simulated corporate network" beginner pentest box — the same shape of exercise you'll find on VulnHub and HackTheBox's easier machines.

## Network Map

Subnet: `10.10.12.0/24` — that's all you get. No target list, no service map. Go find them.

| Container | IP |
|-----------|-----|
| `lab12-attacker` | 10.10.12.2 |
| *(3 more targets somewhere on this subnet)* | ? |

## Quick Start

```bash
cd labs/capstone/lab12-full-chain-ctf
docker compose up -d
docker exec -it lab12-attacker bash
```

## Cleanup

```bash
docker compose down
```

## Practice further

This lab is modeled on the classic De-ICE / "Basic Pentesting" style of VulnHub machine — full recon → enum → exploit → privesc chain, no hints. Once you've finished this one, these are natural next steps at similar difficulty:

| Machine | Why it fits |
|---------|------------|
| **De-ICE: S1.100** (vulnhub.com) | The original inspiration for this lab's shape — FTP, SSH, HTTP, enumerate a password, escalate. |
| **Basic Pentesting: 2** (vulnhub.com) | Web enumeration → credential discovery → SSH → sudo misconfig privesc, same overall flow as this lab. |
