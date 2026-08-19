# Lab 1: Packet Capture & Traffic Analysis

**Phase:** 1 — Reconnaissance
**Tools:** tcpdump, tshark, Wireshark

## Overview

Before you can attack anything, you need to be able to see what's happening on the wire. This lab teaches you to capture live traffic, save it to a `.pcap` file, and analyze it in Wireshark's GUI — reading a cleartext protocol exchange to recover credentials, and recognizing what a port scan looks like on the network.

## Network Map

Subnet: `10.10.1.0/24`

| Container | IP | Role |
|-----------|-----|------|
| `lab1-attacker` | 10.10.1.2 | Kali attacker — run captures and generate traffic from here |
| `lab1-telnet` | 10.10.1.10 | Legacy device simulator — Telnet (port 23), cleartext login |
| `lab1-wireshark` | 10.10.1.5 | Wireshark GUI (browser-based) — `http://localhost:14501` |

## Quick Start

```bash
cd labs/phase1-reconnaissance/lab1-packet-capture
docker compose up -d
docker exec -it lab1-attacker bash
```

Captures are saved to `./captures` on your host, which is also mounted into the Wireshark container — anything you save from the attacker container is instantly openable in the GUI.

## Credentials

- Telnet (`lab1-telnet`): `netadmin` / `cleartext123`

## Cleanup

```bash
docker compose down
```

## Practice further

The technique here — capturing a login and reading it back in plaintext — is the same skill tested on beginner OSCP-style boxes that expose Telnet, FTP, or unencrypted HTTP Basic Auth. Any VulnHub or HackTheBox "easy" Linux box with a legacy service is good follow-on practice once you're comfortable with Wireshark's Follow Stream feature.
