# Ethical Hacking Docker Labs — 5-Phase Edition

> **⚠️ Statutory Warning:** This repository is intended **solely for learning ethical hacking** in isolated, self-contained lab environments. The tools, techniques, and payloads demonstrated here can cause real harm if used against systems you do not own or lack explicit written authorization to test. Unauthorized access to computer systems is illegal under laws such as the Computer Fraud and Abuse Act (US), the Computer Misuse Act (UK), and equivalent statutes elsewhere. The author(s) of this repository are **not responsible** for any misuse, damage, or legal consequences arising from the use of this material outside its intended educational scope. Use responsibly and only on systems you are authorized to test.

Docker-based, self-paced labs for practicing the five phases of ethical hacking:
**Reconnaissance → Scanning & Enumeration → Gaining Access → Maintaining Access → Covering Tracks.**

Each lab is an isolated Docker Compose stack — a Kali Linux attacker container plus purpose-built vulnerable targets — on its own private network. Nothing here touches a real system: every target lives inside the lab's own Docker network and is deliberately built to be broken into.

> **Scope note:** every command in every worksheet is meant to run only against the containers started by that lab's own `docker-compose.yaml`. Don't point these tools at anything else.

---

## Prerequisites

| Tool | Min Version | Install |
|------|-------------|---------|
| Docker Desktop (macOS / Windows) or Docker Engine (Linux) | 24.x | https://docs.docker.com/get-docker/ |
| Docker Compose | v2.x | Bundled with Docker Desktop |
| Git | Any | https://git-scm.com/ |
| Make | Any | macOS: `xcode-select --install` · Linux: `sudo apt install make` · Windows: Git Bash or WSL2 |

**Recommended:** 8 GB RAM, 20 GB free disk space.

> **Windows users** — run all commands in **Git Bash** or **WSL2**. PowerShell equivalents are given inline where they differ.

---

## Installation

### 1. Build the shared Kali attacker image

All labs share one base image (`ethical-base`) built from [`base.Dockerfile`](./base.Dockerfile) — Kali Linux Rolling with:

`nmap` · `hydra` · `medusa` · `john` · `hashcat` · `wireshark`/`tshark`/`tcpdump` · `gobuster` · `dirb` · `ffuf` · `nikto` · `sqlmap` · `enum4linux` · `smbclient` · `ldap-utils` · `netcat` · `socat` · `proxychains4` · `exploitdb` (`searchsploit`) · `gdb` · `python3-pwntools` · `python3-impacket` · `whois` · `dig`/`nslookup` · `telnet` · `ftp` · `rockyou` wordlist

```bash
make build-base
# or without make:
docker build -t ethical-base -f base.Dockerfile .
```

Verify: `docker images | grep ethical-base`

### 2. Run a lab

```bash
make run-lab3      # replace 3 with the lab number — see table below
```

Or directly:

```bash
cd labs/phase2-scanning-enumeration/lab3-nmap-scanning
docker compose up -d
docker exec -it lab3-attacker bash
```

Each lab's `README.md` gives the exact attacker container name and target map. Open the lab's `worksheet.md` and work through it top to bottom.

### 3. Stop a lab

```bash
cd labs/phase2-scanning-enumeration/lab3-nmap-scanning
docker compose down
```

Or stop everything: `make stop-all`

---

## Lab Map

| # | Phase | Lab | Tools you'll practice |
|---|-------|-----|------------------------|
| 1 | **1 — Reconnaissance** | [Packet Capture & Traffic Analysis](labs/phase1-reconnaissance/lab1-packet-capture/) | Wireshark, tcpdump, tshark |
| 2 | **1 — Reconnaissance** | [OSINT & Active Host Discovery](labs/phase1-reconnaissance/lab2-osint-recon/) | whois, dig/nslookup, curl banner-grabbing, nmap -sn/-sL |
| 3 | **2 — Scanning & Enumeration** | [Nmap Port & Service Scanning](labs/phase2-scanning-enumeration/lab3-nmap-scanning/) | nmap (-sV, -sC, -A, -sS, NSE scripts) |
| 4 | **2 — Scanning & Enumeration** | [Web Enumeration](labs/phase2-scanning-enumeration/lab4-web-enumeration/) | gobuster, dirb, ffuf, nikto |
| 5 | **2 — Scanning & Enumeration** | [Directory Service & DB Enumeration](labs/phase2-scanning-enumeration/lab5-service-enumeration/) | enum4linux, smbclient, ldapsearch, mysql client |
| 6 | **3 — Gaining Access** | [Password Attacks](labs/phase3-gaining-access/lab6-password-attacks/) | Hydra, Medusa, John the Ripper, Hashcat |
| 7 | **3 — Gaining Access** | [Web Application Exploitation](labs/phase3-gaining-access/lab7-web-exploitation/) | sqlmap, DVWA, OWASP Juice Shop |
| 8 | **3 — Gaining Access** | [Exploit Development (Buffer Overflow)](labs/phase3-gaining-access/lab8-buffer-overflow/) | gdb, pwntools, gcc |
| 9 | **4 — Maintaining Access** | [Lateral Movement & Pivoting](labs/phase4-maintaining-access/lab9-pivoting/) | SSH tunneling, proxychains4, Metasploit |
| 10 | **4 — Maintaining Access** | [Persistence & Backdoors](labs/phase4-maintaining-access/lab10-persistence/) | cron backdoors, SSH key persistence, netcat/socat shells |
| 11 | **5 — Covering Tracks** | [Log Manipulation & Anti-Forensics](labs/phase5-covering-tracks/lab11-log-anti-forensics/) | bash history control, log editing, timestomping, shred |
| 12 | **Capstone** | [Full-Chain CTF](labs/capstone/lab12-full-chain-ctf/) | Everything above, chained end-to-end against one multi-service target |

Each lab folder contains:

- `README.md` — overview, network map, target credentials
- `worksheet.md` — guided, step-by-step exercises (the thing you actually work through)
- `docker-compose.yaml` — the full stack definition
- `ctf-challenge.md` — optional flag-capture objective (no hints)
- `ctf-walkthrough.md` — the answer key, for after you've tried

---

## Network Architecture

Every lab uses its own `10.10.N.0/24` subnet, where `N` is the lab number — the lab number is always visible in the target IPs. The attacker container is always `.2` unless a lab's README says otherwise.

| Lab | Subnet |
|-----|--------|
| 1 | 10.10.1.0/24 |
| 2 | 10.10.2.0/24 |
| 3 | 10.10.3.0/24 |
| 4 | 10.10.4.0/24 |
| 5 | 10.10.5.0/24 |
| 6 | 10.10.6.0/24 |
| 7 | 10.10.7.0/24 |
| 8 | 10.10.8.0/24 |
| 9 (external) | 10.10.9.0/24 |
| 9 (internal) | 10.10.90.0/24 |
| 10 | 10.10.10.0/24 |
| 11 | 10.10.11.0/24 |
| 12 | 10.10.12.0/24 |

> **Lab 9's internal network** is `internal: true` — completely isolated and unreachable without pivoting through the lab's pivot host. That's the point of the lab.

---

## Optional CTF Challenges

Every lab includes an optional Capture The Flag objective. Two flags are hidden in the target containers:

- `user.txt` — earned via initial access / enumeration
- `root.txt` — earned via deeper exploitation or privilege escalation

Flag format: `flag{...}`. Work from `ctf-challenge.md` — no hints given. `ctf-walkthrough.md` has the full solution for when you're stuck or want to check your work.

---

## Repository Structure

```
Hacking-Labs/
├── base.Dockerfile              # Shared Kali attacker image
├── Makefile                     # build-base, run-labN, stop-all, clean-all
└── labs/
    ├── phase1-reconnaissance/
    │   ├── lab1-packet-capture/
    │   └── lab2-osint-recon/
    ├── phase2-scanning-enumeration/
    │   ├── lab3-nmap-scanning/
    │   ├── lab4-web-enumeration/
    │   └── lab5-service-enumeration/
    ├── phase3-gaining-access/
    │   ├── lab6-password-attacks/
    │   ├── lab7-web-exploitation/
    │   └── lab8-buffer-overflow/
    ├── phase4-maintaining-access/
    │   ├── lab9-pivoting/
    │   └── lab10-persistence/
    ├── phase5-covering-tracks/
    │   └── lab11-log-anti-forensics/
    └── capstone/
        └── lab12-full-chain-ctf/
```

---

## Troubleshooting

**`make build-base` fails with a network error**
Docker isn't running, or there's no internet access. Start Docker Desktop and retry.

**`docker compose up` fails with "port already in use"**
Another lab is still running on a conflicting port. Run `make stop-all` first.

**Container exits immediately**
Check logs: `docker logs <container-name>`.

**Lab 9 internal targets are unreachable**
That's intentional — set up SSH port forwarding through the pivot host first. See `labs/phase4-maintaining-access/lab9-pivoting/worksheet.md`.

---

Built for practicing the five phases of ethical hacking against disposable, purpose-built targets. Only run these tools against the containers each lab starts.
