# Lab 4: Web Enumeration
## Phase 2 — Scanning & Enumeration | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only scan `10.10.4.10` — the container this lab starts. (Running these same tools against a real website you don't own or have permission to test is a different matter entirely — keep this practice here.)

**What you're practicing:** finding content a web server hosts but doesn't link to — the second half of web recon, after you already know a service is HTTP.

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase2-scanning-enumeration/lab4-web-enumeration
docker compose up -d
docker exec -it lab4-attacker bash
curl -I http://10.10.4.10
```

**Check:** Did you get a `200 OK`? ✓ Yes ✓ No

---

## Part 1: Check the Obvious First (10 minutes)

### Exercise 1.1: robots.txt

Before brute-forcing anything, always check `robots.txt` — it exists to tell *search engine crawlers* what to skip, which ironically makes it a great list of "paths the owner doesn't want indexed."

```bash
curl http://10.10.4.10/robots.txt
```

**What paths does it disallow?**

_________________________________

**Question:** Why would a path being listed in `robots.txt` make it *more* interesting to check manually, not less?

_________________________________

---

## Part 2: Directory Brute-Forcing (25 minutes)

### Exercise 2.1: gobuster

```bash
gobuster dir -u http://10.10.4.10 -w /usr/share/dirb/wordlists/common.txt
```

**List every directory/file gobuster found, with its status code:**

| Path | Status |
|------|--------|
|      |        |
|      |        |
|      |        |

### Exercise 2.2: dirb

```bash
dirb http://10.10.4.10 /usr/share/dirb/wordlists/common.txt
```

**Question:** Did dirb find the same paths as gobuster? Note any differences in what each tool reported.

_________________________________

### Exercise 2.3: ffuf

`ffuf` uses an explicit `FUZZ` keyword in the URL to mark where the wordlist gets substituted:

```bash
ffuf -w /usr/share/dirb/wordlists/common.txt -u http://10.10.4.10/FUZZ
```

**Question:** `ffuf` is generally much faster than `dirb`. What in its output (besides speed) tells you it found a real hit versus a false positive?

_________________________________

---

## Part 3: Following Up on What You Found (15 minutes)

### Exercise 3.1: Visit the discovered admin path

```bash
curl -s http://10.10.4.10/admin/
```

**Did the page contain anything interesting in an HTML comment?** ✓ Yes ✓ No — write what it said: _________________________________

### Exercise 3.2: Act on a filename the page mentioned

A brute-force wordlist can only find paths that are *in the wordlist*. Once a page tells you an exact filename, request it directly — that's manual enumeration picking up where automated enumeration stops.

```bash
curl -s http://10.10.4.10/backup/<filename-you-found>
```

**What did the file contain?**

_________________________________

**Question:** Why couldn't gobuster/dirb/ffuf have found this file on their own, even with a good wordlist?

_________________________________

---

## Part 4: Automated Vulnerability Scanning with Nikto (15 minutes)

### Exercise 4.1: Run nikto

```bash
nikto -h http://10.10.4.10
```

**What did nikto report about the server version / headers?**

_________________________________

**Did nikto flag anything about missing security headers?** ✓ Yes ✓ No — list one:

_________________________________

**Question:** `nikto` and `gobuster`/`dirb` both probe a web server, but for different things. In one sentence, what's the difference in what each is designed to find?

_________________________________

---

## Quick Knowledge Check

1. What does `robots.txt` actually control?
   - A) Which paths require login  B) Which paths search-engine crawlers should skip  C) Server-side access control  D) SSL certificate validation

2. In `ffuf -u http://target/FUZZ`, what does `FUZZ` represent?
   - A) A literal folder name  B) The substitution point where each wordlist entry gets inserted  C) A HTTP header  D) An IP range

3. What kind of file will directory brute-forcing with a generic wordlist *never* find on its own?
   - A) Common folder names like `/admin/`  B) A file with an unpredictable or context-specific name mentioned nowhere else  C) The homepage  D) `robots.txt`

4. What is nikto primarily designed to check for?
   - A) Only directory names  B) Server misconfigurations, outdated software banners, missing security headers, and known-risky files  C) Only SQL injection  D) DNS records

5. Why check `robots.txt` before running a full directory brute-force?
   - A) It's required by law  B) It's an instant, free hint at paths the site owner considers sensitive  C) It speeds up gobuster automatically  D) It isn't useful

---

## Cleanup

```bash
exit
cd labs/phase2-scanning-enumeration/lab4-web-enumeration
docker compose down
```

---

## Summary

Today you learned to:
✓ Check `robots.txt` as a first, free recon step
✓ Brute-force directories/files with gobuster, dirb, and ffuf
✓ Follow up on a discovery manually to find content wordlists can't
✓ Run nikto for automated misconfiguration checks

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Two flags — one found through brute-forcing, one found by reading and following up on what you found. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
