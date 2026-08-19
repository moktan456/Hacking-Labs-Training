# Lab 2: OSINT & Active Host Discovery
## Phase 1 — Reconnaissance | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** the local targets in Part 2–4 only exist on this lab's `10.10.2.0/24` network. Part 1 looks up `example.com`/`iana.org`, which are domains permanently reserved by IANA for documentation and testing — safe to query from anywhere, any time.

**What you're practicing:** the difference between passive recon (public records, no contact with the target) and active recon (pings, banner grabs — lightweight but detectable contact).

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase1-reconnaissance/lab2-osint-recon
docker compose up -d
docker exec -it lab2-attacker bash
ping -c 2 10.10.2.5
```

**Check:** Ping replies from the DNS server? ✓ Yes ✓ No

---

## Part 1: Passive OSINT Against a Real Domain (15 minutes)

`example.com` is IANA-reserved specifically so people can safely practice exactly this.

### Exercise 1.1: WHOIS lookup

```bash
whois example.com
```

**Who is the registrant organization listed?** _________________________________

**What are the listed name servers?** _________________________________

### Exercise 1.2: DNS records

> **Note:** query a known public resolver explicitly with `@1.1.1.1` rather than trusting whatever default resolver your environment has configured — a local/default resolver can be slow, filtered, or (on a real engagement, if you're on the target's network) intercepted.

```bash
dig @1.1.1.1 example.com A
dig @1.1.1.1 example.com MX
dig @1.1.1.1 example.com NS
```

**What's the A record's IP address?** _________________________________

**Question:** Why would an attacker care about MX records specifically, during recon on a real target?

_________________________________

---

## Part 2: Local Host Discovery (15 minutes)

### Exercise 2.1: List scan (no packets sent)

```bash
nmap -sL 10.10.2.0/24
```

**Question:** `-sL` doesn't touch the targets at all — it just does reverse-DNS lookups. Why might you run this before anything else on an unfamiliar network?

_________________________________

### Exercise 2.2: Ping sweep

```bash
nmap -sn 10.10.2.0/24
```

**Which hosts responded?**

| IP | Responded? |
|----|-----------|
| 10.10.2.5  |  |
| 10.10.2.10 |  |
| 10.10.2.11 |  |

---

## Part 3: DNS Zone Enumeration (20 minutes)

### Exercise 3.1: Query known records

```bash
dig @10.10.2.5 www.cybercorp.lab
dig @10.10.2.5 mail.cybercorp.lab
```

**What IPs did you get back?** _________________________________

### Exercise 3.2: Attempt a zone transfer

A DNS zone transfer (`AXFR`) is meant only for secondary name servers to sync from the primary — but a misconfigured server will hand the *entire* zone to anyone who asks.

```bash
dig @10.10.2.5 cybercorp.lab AXFR
```

**Did the transfer succeed?** ✓ Yes ✓ No

**List every hostname the zone transfer revealed, including any you hadn't seen yet:**

_________________________________

**Did you find a TXT record?** ✓ Yes ✓ No — copy its contents here: _________________________________

**Question:** You found a hostname (`admin-portal.cybercorp.lab`) that was never advertised anywhere public. What does that tell you about the value of a misconfigured AXFR?

_________________________________

---

## Part 4: Banner Grabbing (15 minutes)

### Exercise 4.1: HTTP banner via curl

```bash
curl -I http://10.10.2.10
```

**What does the `Server:` header reveal?** _________________________________

### Exercise 4.2: Read the page source

```bash
curl -s http://10.10.2.10 | grep -i "TODO\|backup\|<!--"
```

**Did the HTML contain a comment referencing something interesting?** ✓ Yes ✓ No

Follow up on what it says:

```bash
curl -s http://10.10.2.10/backup.txt
```

**What did you find?** _________________________________

### Exercise 4.3: Raw banner grab with nc

```bash
nc -nv 10.10.2.11 21
# Ctrl+C once you've read the banner

nc -nv 10.10.2.11 22
# Ctrl+C once you've read the banner
```

**FTP banner:** _________________________________

**SSH banner:** _________________________________

**Question:** The FTP banner claims to be `vsftpd 2.3.4`. Why would an attacker specifically care about the *exact version number* of a service, rather than just knowing "it's FTP"?

_________________________________

---

## Quick Knowledge Check

1. Which of these is passive reconnaissance?
   - A) Port scanning  B) WHOIS lookup  C) Banner grabbing  D) Ping sweep

2. What does `nmap -sL` do differently from `nmap -sn`?
   - A) Sends no packets to the targets at all, just resolves names  B) Only pings  C) Full port scan  D) OS detection

3. What is a DNS zone transfer (AXFR) meant to be used for?
   - A) Client DNS lookups  B) Syncing zone data between primary and secondary name servers  C) Encrypting DNS traffic  D) Blocking DNS queries

4. Why is an exact software version (like "vsftpd 2.3.4") valuable during recon?
   - A) It isn't — version numbers don't matter  B) It lets you look up known vulnerabilities for that specific version  C) It tells you the admin's name  D) It reveals the OS install date

5. What HTTP client flag returns only the response headers, not the body?
   - A) `-s`  B) `-I`  C) `-v`  D) `-X`

---

## Cleanup

```bash
exit
cd labs/phase1-reconnaissance/lab2-osint-recon
docker compose down
```

---

## Summary

Today you learned to:
✓ Run WHOIS and DNS lookups against a real, safe domain
✓ Distinguish passive from active reconnaissance
✓ Enumerate a network with `nmap -sL` and `-sn`
✓ Exploit a misconfigured DNS zone transfer to enumerate hidden hosts
✓ Grab service banners with curl and nc, and explain why version numbers matter

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Two flags: one hidden in a DNS TXT record, one hidden behind a page-source clue. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
