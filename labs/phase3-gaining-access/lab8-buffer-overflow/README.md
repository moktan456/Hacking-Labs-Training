# Lab 8: Exploit Development (Buffer Overflow)

**Phase:** 3 — Gaining Access
**Tools:** gdb, pwntools, gcc

## Overview

Not every way in is a known CVE or a leaked password — sometimes you write your own exploit. This lab walks through the classic **ret2win** stack buffer overflow: a program with a hidden `win()` function that's never called, and a vulnerable `read()` into a fixed-size buffer that lets you overwrite the return address to jump there yourself.

## Network Map

Subnet: `10.10.8.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab8-attacker` | 10.10.8.2 | Kali attacker — gdb, pwntools, gcc pre-installed |
| `lab8-recon` | 10.10.8.10 | HTTP recon target — background context only |
| `lab8-vuln-target` | 10.10.8.11 | SSH (initial access) + the vulnerable service on port 9999 |

## Quick Start

```bash
cd labs/phase3-gaining-access/lab8-buffer-overflow
docker compose up -d
docker exec -it lab8-attacker bash
```

A local copy of the exact same pre-built binary the target runs is available at `/root/tools/vuln` inside the attacker container — analyze it locally with gdb, then aim your exploit at the real service over the network. (It's pre-built rather than compiled fresh on each side deliberately: the attacker and target containers run different base images with different toolchains, and compiling "the same" source separately on each does not reliably produce byte-identical addresses.)

## Credentials

- SSH: `lowpriv` / `lowpriv123`

## Cleanup

```bash
docker compose down
```
