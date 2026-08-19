# Lab 5: Directory Service & DB Enumeration

**Phase:** 2 — Scanning & Enumeration
**Tools:** enum4linux, ldapsearch, smbclient, mysql client

## Overview

Ports found by nmap are just the start — real enumeration means talking to each service in its own protocol to pull out usernames, shares, database names, and anything else that helps plan the next phase. This lab covers three of the most common enterprise services: LDAP (directory services), SMB (file shares), and MySQL (databases).

## Network Map

Subnet: `10.10.5.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab5-attacker` | 10.10.5.2 | Kali attacker |
| `lab5-ldap` | 10.10.5.10 | OpenLDAP directory, domain `cybercorp.local` |
| `lab5-mysql` | 10.10.5.11 | MySQL 8.0, database `corpdb` |
| `lab5-smb` | 10.10.5.12 | Samba file server — public + private shares |

## Quick Start

```bash
cd labs/phase2-scanning-enumeration/lab5-service-enumeration
docker compose up -d
docker exec -it lab5-attacker bash
```

## Credentials (for later exercises — try enumeration without them first)

- LDAP admin: `cn=admin,dc=cybercorp,dc=local` / `admin123`
- LDAP readonly: `readonly` / `readonly123`
- MySQL: `dbuser` / `dbpass123` (root: `toor`)
- SMB: `alice` / `alice123`, `bob` / `bob456`

## Cleanup

```bash
docker compose down
```
