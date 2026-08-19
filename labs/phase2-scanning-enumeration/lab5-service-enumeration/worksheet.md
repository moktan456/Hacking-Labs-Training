# Lab 5: Directory Service & DB Enumeration
## Phase 2 — Scanning & Enumeration | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only enumerate `10.10.5.0/24` — the containers this lab starts.

**What you're practicing:** pulling structured information out of three of the most common enterprise services — LDAP, SMB, and MySQL — first anonymously, then with the credentials you're given later in the sheet.

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase2-scanning-enumeration/lab5-service-enumeration
docker compose up -d
docker exec -it lab5-attacker bash
nmap -sV 10.10.5.0/24
```

**Check:** Did nmap report LDAP (389), MySQL (3306), and SMB (445)? ✓ Yes ✓ No

---

## Part 1: LDAP Enumeration (20 minutes)

### Exercise 1.1: Anonymous bind attempt

```bash
ldapsearch -x -H ldap://10.10.5.10 -b "dc=cybercorp,dc=local"
```

**What happened — did you get directory entries back, or a permissions error?**

_________________________________

### Exercise 1.2: Authenticated search

```bash
ldapsearch -x -H ldap://10.10.5.10 -D "cn=readonly,dc=cybercorp,dc=local" -w readonly123 -b "dc=cybercorp,dc=local"
```

**Question:** Compare this result to Exercise 1.1. What changed once you authenticated, even with a low-privilege read-only account?

_________________________________

### Exercise 1.3: Query specific attributes

```bash
ldapsearch -x -H ldap://10.10.5.10 -D "cn=readonly,dc=cybercorp,dc=local" -w readonly123 -b "dc=cybercorp,dc=local" "(objectClass=organizationalUnit)"
```

**What organizational units (OUs) exist in this directory?**

_________________________________

---

## Part 2: SMB Enumeration (20 minutes)

### Exercise 2.1: List shares anonymously

```bash
smbclient -L 10.10.5.12 -N
```

**What shares are listed?**

| Share | Comment |
|-------|---------|
|       |         |
|       |         |

### Exercise 2.2: enum4linux automated enumeration

```bash
enum4linux -a 10.10.5.12
```

**What information did enum4linux pull automatically that you'd otherwise have to gather manually?**

_________________________________

### Exercise 2.3: Access the public share

```bash
smbclient //10.10.5.12/public -N
# smb: \> ls
# smb: \> get user.txt
# smb: \> exit
cat user.txt
```

**Did you retrieve a flag?** ✓ Yes ✓ No: _________________________________

### Exercise 2.4: Try the private share without credentials, then with them

```bash
smbclient //10.10.5.12/private -N
```

**What happened?** _________________________________

```bash
smbclient //10.10.5.12/private -U alice%alice123
# smb: \> ls
# smb: \> get root.txt
# smb: \> exit
cat root.txt
```

**Did you retrieve a flag this time?** ✓ Yes ✓ No: _________________________________

**Question:** What's the practical difference, from an attacker's perspective, between a share that's merely unlisted versus one that actually enforces authentication?

_________________________________

---

## Part 3: MySQL Enumeration (15 minutes)

### Exercise 3.1: Connect with application credentials

```bash
mysql -h 10.10.5.11 -u dbuser -pdbpass123 --skip-ssl -e "SHOW DATABASES;"
```

**What databases are visible to `dbuser`?**

_________________________________

### Exercise 3.2: Enumerate tables and data

```bash
mysql -h 10.10.5.11 -u dbuser -pdbpass123 --skip-ssl corpdb -e "SHOW TABLES;"
mysql -h 10.10.5.11 -u dbuser -pdbpass123 --skip-ssl corpdb -e "SELECT * FROM users;"
mysql -h 10.10.5.11 -u dbuser -pdbpass123 --skip-ssl corpdb -e "SELECT * FROM notes;"
```

**What usernames/roles did you find in the `users` table?**

_________________________________

**Did the `notes` table contain anything interesting?** ✓ Yes ✓ No: _________________________________

**Question:** `dbuser` is meant to be an application account, not an admin account. Why is it still worth enumerating what an app-level account can see, rather than only going after `root`?

_________________________________

---

## Quick Knowledge Check

1. What does `smbclient -L <target> -N` do?
   - A) Lists shares with a null (anonymous) session  B) Deletes a share  C) Lists local files  D) Forces authentication

2. What's the main advantage of `enum4linux -a` over doing SMB enumeration manually?
   - A) It's stealthier  B) It automates and combines several SMB/NetBIOS enumeration checks into one run  C) It cracks passwords  D) It only works on Windows

3. In `ldapsearch`, what does `-D` specify?
   - A) The base DN to search under  B) The distinguished name (identity) to bind as  C) The LDAP server URL  D) A search filter

4. Why check both anonymous and authenticated access during LDAP/SMB enumeration?
   - A) There's no reason to check both  B) Some information is only exposed once authenticated, even with low-privilege credentials  C) Anonymous access is always more revealing  D) Authentication is never required

5. What MySQL client flag lets you pass the password inline without a prompt?
   - A) `-h`  B) `-u`  C) `-p<password>` (no space)  D) `-e`

---

## Cleanup

```bash
exit
cd labs/phase2-scanning-enumeration/lab5-service-enumeration
docker compose down
```

---

## Summary

Today you learned to:
✓ Enumerate an LDAP directory anonymously and authenticated
✓ List and access SMB shares with smbclient, and automate the process with enum4linux
✓ Compare unlisted vs. authenticated-only share protections
✓ Enumerate a MySQL server's databases, tables, and data with application-level credentials

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Two flags — one on the public SMB share, one on the private share. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
