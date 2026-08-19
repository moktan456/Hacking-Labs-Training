# Lab 6: Password Attacks

**Phase:** 3 — Gaining Access
**Tools:** Hydra, Medusa, John the Ripper, Hashcat

## Overview

Weak passwords remain one of the most reliable ways into a system. This lab covers both sides of password attacks: **offline** cracking of hashes you already have (John, Hashcat) and **online** brute-forcing of live login services (Hydra, Medusa).

## Network Map

Subnet: `10.10.6.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab6-attacker` | 10.10.6.2 | Kali attacker — wordlists and hashes pre-loaded |
| `lab6-ssh` | 10.10.6.10 | SSH target with weak passwords |
| `lab6-web` | 10.10.6.11 | HTTP login form for `hydra http-post-form` practice |

## Quick Start

```bash
cd labs/phase3-gaining-access/lab6-password-attacks
docker compose up -d
docker exec -it lab6-attacker bash
```

Wordlists are mounted at `/wordlists`, sample hashes at `/hashes`. The full `rockyou.txt` wordlist is also available at `/usr/share/wordlists/rockyou.txt` inside the attacker container.

## Cleanup

```bash
docker compose down
```
