# Lab 3: Nmap Port & Service Scanning
## Phase 2 — Scanning & Enumeration | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only scan `10.10.3.0/24` — the containers this lab starts.

**What you're practicing:** the standard nmap workflow you'll reuse in every later lab — discover hosts, find open ports, identify exact service versions, and run NSE scripts for automated checks.

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase2-scanning-enumeration/lab3-nmap-scanning
docker compose up -d
docker exec -it lab3-attacker bash
ping -c 2 10.10.3.10
```

**Check:** Ping replies? ✓ Yes ✓ No — if not, run `docker compose ps` and confirm all containers show `Up`.

---

## Part 1: Basic Port Scanning (20 minutes)

### Exercise 1.1: Default TCP scan

```bash
nmap 10.10.3.10
```

**Open ports found:**

| Port | Protocol | State |
|------|----------|-------|
|      |          |       |

**Question:** What does it mean when nmap reports a port as "filtered" rather than "closed"?

_________________________________

### Exercise 1.2: Scan the full lab subnet

```bash
nmap 10.10.3.0/24
```

**How many hosts are up?** _____

**List each host and its open ports:**

| Host IP | Open Ports |
|---------|------------|
|         |            |
|         |            |
|         |            |

### Exercise 1.3: Ping sweep (host discovery only)

```bash
nmap -sn 10.10.3.0/24
```

**Question:** Why run `-sn` before a full port scan on a large, unfamiliar network?

_________________________________

---

## Part 2: Service Version Detection (20 minutes)

### Exercise 2.1: Version scan

```bash
nmap -sV 10.10.3.10
nmap -sV 10.10.3.11
nmap -sV 10.10.3.12
```

**Fill in the service version table:**

| Target IP | Port | Service | Version |
|-----------|------|---------|---------|
| 10.10.3.10 | 80 | | |
| 10.10.3.11 | 21 | | |
| 10.10.3.12 | 22 | | |

**Question:** Why is knowing the exact version of a service valuable during recon/scanning, before you've attempted anything against it?

_________________________________

### Exercise 2.2: Aggressive scan

```bash
nmap -A 10.10.3.0/24
```

While it runs, read ahead.

**What additional information did `-A` reveal compared to `-sV` alone?**

_________________________________

**Did nmap detect an OS for any target?** ✓ Yes ✓ No — which target, and what OS? _________________________________

---

## Part 3: Scan Techniques and Detection Signatures (20 minutes)

### Exercise 3.1: SYN scan vs. full connect scan

```bash
nmap -sS 10.10.3.0/24
nmap -sT 10.10.3.0/24
```

**Question:** How does a SYN scan (`-sS`) differ mechanically from a full connect scan (`-sT`)?

_________________________________

**Which leaves a more complete connection log entry on the target, and why?**

_________________________________

### Exercise 3.2: NSE script scans

```bash
nmap -sC -sV 10.10.3.11
nmap --script ftp-anon 10.10.3.11
```

**Does the FTP server allow anonymous login?** ✓ Yes ✓ No

**Question:** What's the practical risk of a service allowing anonymous read access?

_________________________________

### Exercise 3.3: SSH enumeration scripts

```bash
nmap --script ssh-hostkey 10.10.3.12
nmap --script ssh-auth-methods --script-args="ssh.user=sysadmin" 10.10.3.12
```

**What authentication methods does the SSH server advertise?**

_________________________________

---

## Part 4: Output and Documentation (15 minutes)

### Exercise 4.1: Save scan results in all formats

```bash
nmap -sV -oA /tmp/lab3-scan 10.10.3.0/24
ls /tmp/lab3-scan*
cat /tmp/lab3-scan.nmap
```

**What's the `.xml` output format useful for, that the plain-text `.nmap` format isn't?**

_________________________________

### Exercise 4.2: Write a recon summary

**Target Network:** 10.10.3.0/24

| IP | Hostname | OS (if detected) | Open Ports | Key Services |
|----|----------|-------------------|-------------|----------------|
|    |          |                   |             |                |
|    |          |                   |             |                |
|    |          |                   |             |                |

**Notable findings:**

1. ___________________________
2. ___________________________
3. ___________________________

**What would you scan/enumerate next, based on these results?**

_________________________________

---

## Quick Knowledge Check

1. What flag enables service version detection?
   - A) `-sV`  B) `-sS`  C) `-A`  D) `-p`

2. What does `-sn` do?
   - A) Scan all ports  B) Ping sweep only (host discovery, no ports)  C) Enable NSE scripts  D) OS fingerprinting

3. Which nmap output format is best for feeding into other tools?
   - A) `.nmap` (normal)  B) `.xml`  C) `.gnmap`  D) Plain text

4. What does "filtered" mean in nmap's output?
   - A) Port is open  B) Port is closed  C) A firewall/ACL may be blocking the probe, so nmap can't tell  D) Port doesn't exist

5. What does the `-A` flag combine?
   - A) Just version detection  B) Version detection + OS detection + script scanning + traceroute  C) Only OS detection  D) Only NSE scripts

---

## Cleanup

```bash
exit
cd labs/phase2-scanning-enumeration/lab3-nmap-scanning
docker compose down
```

---

## Summary

Today you learned to:
✓ Run host discovery and full-subnet port scans
✓ Detect service versions with `-sV`
✓ Compare SYN scans to full connect scans
✓ Use NSE scripts for automated service checks
✓ Save and document scan output for later reference

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Two flags, findable through scanning and enumeration alone — no credentials required. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
