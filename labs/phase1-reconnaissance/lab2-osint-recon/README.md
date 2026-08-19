# Lab 2: OSINT & Active Host Discovery

**Phase:** 1 — Reconnaissance
**Tools:** whois, dig, nslookup, curl, nc, nmap (-sn, -sL)

## Overview

Reconnaissance splits into two flavors: **passive** (gathering public information without touching the target — whois, DNS records, public web pages) and **active** (lightly touching the target's network — ping sweeps, banner grabs). This lab covers both. You'll query real public registry data for a safe, reserved-for-documentation domain, then pivot to a simulated internal network to enumerate a misconfigured DNS server and grab service banners.

## Network Map

Subnet: `10.10.2.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab2-attacker` | 10.10.2.2 | Kali attacker |
| `lab2-dns` | 10.10.2.5 | Internal DNS server for `cybercorp.lab` — zone transfer misconfigured |
| `lab2-web` | 10.10.2.10 | Internal web portal — page source leaks a path |
| `lab2-legacy` | 10.10.2.11 | Legacy FTP + SSH gateway — revealing service banners |

## Quick Start

```bash
cd labs/phase1-reconnaissance/lab2-osint-recon
docker compose up -d
docker exec -it lab2-attacker bash
```

## Note on internet access

Part 1 of this lab queries `example.com`, which is an IANA-reserved domain explicitly set aside for documentation and testing, so looking it up is always safe. Your attacker container needs outbound internet access for that part only — everything else in this lab is fully local. If your network's default DNS resolver behaves oddly (some Docker/corporate setups filter or cache unexpectedly), the worksheet has you query a public resolver directly (`dig @1.1.1.1 ...`) to sidestep that, which is also just good recon practice.

## Cleanup

```bash
docker compose down
```
