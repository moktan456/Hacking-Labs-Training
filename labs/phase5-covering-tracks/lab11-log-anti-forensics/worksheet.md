# Lab 11: Log Manipulation & Anti-Forensics
## Phase 5 — Covering Tracks | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only target this lab's own containers.

**What you're practicing:** the fifth phase of the attack lifecycle — removing or falsifying the evidence that you were ever there. Every technique here has a defensive mirror (log integrity monitoring, file integrity checking, centralized logging) — knowing the attack side is what makes the defense side make sense.

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase5-covering-tracks/lab11-log-anti-forensics
docker compose up -d
```

### Exercise 0.1: Generate some noise first

You need real evidence on disk before you can practice erasing it. From the attacker container:

```bash
docker exec -it lab11-attacker bash

# One failed attempt (wrong password on purpose)
sshpass -p wrongpass ssh -o StrictHostKeyChecking=no root@10.10.11.10 whoami 2>&1 || true

# Now the real login
ssh root@10.10.11.10
# password: toor123
cat user.txt
whoami
ls -la
exit
```

**Important:** that `exit` matters — bash only writes your command history to disk when a session ends normally. Logging out here is what makes Part 1 meaningful.

---

## Part 1: Bash History (15 minutes)

### Exercise 1.1: See what's already there

```bash
ssh root@10.10.11.10
cat ~/.bash_history
```

**Did you see the commands from your previous session?** ✓ Yes ✓ No

### Exercise 1.2: Prevent new commands from being logged

For the rest of this session, stop new commands from ever reaching disk:

```bash
unset HISTFILE
```

**Question:** `unset HISTFILE` only helps going forward. Why doesn't it erase what's already on disk from before you ran it?

_________________________________

### Exercise 1.3: Clear what's already there

```bash
history -c
> ~/.bash_history
cat ~/.bash_history
```

**Is the file empty now?** ✓ Yes ✓ No

**Question:** `history -c` clears your *in-memory* history for this session. Why was the separate `> ~/.bash_history` (truncating the file directly) also necessary?

_________________________________

---

## Part 2: Auth Log Cleanup (20 minutes)

### Exercise 2.1: Find your own entries

```bash
grep "10.10.11.2" /var/log/auth.log
```

**How many lines reference your attacker IP?** _____

**What do the failed vs. successful attempts look like differently in the log?**

_________________________________

### Exercise 2.2: Remove just those lines

```bash
sed -i '/10.10.11.2/d' /var/log/auth.log
grep "10.10.11.2" /var/log/auth.log
```

**Is the grep now empty?** ✓ Yes ✓ No

**Question:** This used `sed -i` to selectively delete matching lines rather than truncating the whole file (`> /var/log/auth.log`). Why is selective deletion less suspicious to a defender than an empty log file?

_________________________________

---

## Part 3: Login Records — wtmp (15 minutes)

`auth.log` isn't the only record of a login — `wtmp` is a separate binary log that the `last` command reads.

### Exercise 3.1: View login records

```bash
last -f /var/log/wtmp
```

**Do you see your SSH sessions listed?** ✓ Yes ✓ No

### Exercise 3.2: Clear it

```bash
> /var/log/wtmp
last -f /var/log/wtmp
```

**Question:** Both `auth.log` and `wtmp` recorded the same login events, in two completely different formats (text log vs. binary record). Why does covering your tracks properly require handling both, not just one?

_________________________________

---

## Part 4: Timestomping (15 minutes)

A freshly modified file stands out. Matching its timestamp to something already on the system blends it in.

### Exercise 4.1: Compare timestamps

```bash
stat /root/dropped_tool.sh
stat /root/legit_reference.txt
```

**How do the `Modify` timestamps differ?**

_________________________________

### Exercise 4.2: Match them

```bash
touch -r /root/legit_reference.txt /root/dropped_tool.sh
stat /root/dropped_tool.sh
```

**Do the `Modify` timestamps match now?** ✓ Yes ✓ No

**Question:** `touch -r` copies a reference file's timestamp. What's the risk of picking a *badly chosen* reference file (e.g. one that was itself created five minutes ago)?

_________________________________

---

## Part 5: Secure Deletion (10 minutes)

### Exercise 5.1: Create and delete a file normally

```bash
echo "sensitive staging notes" > /root/scratch.txt
rm /root/scratch.txt
```

**Question:** `rm` removes the filename from the directory listing, but does it necessarily erase the file's actual data from disk? What could a forensic recovery tool potentially still find?

_________________________________

### Exercise 5.2: Delete it securely instead

```bash
echo "sensitive staging notes" > /root/scratch2.txt
shred -u /root/scratch2.txt
ls /root/scratch2.txt 2>&1
```

**Question:** What does `shred` actually do differently from `rm` before removing the file?

_________________________________

---

## Part 6: Verify Your Work (5 minutes)

```bash
bash /root/verify.sh
```

**Did every check pass?** ✓ Yes ✓ No

If something failed, go back and fix it, then run `verify.sh` again.

---

## Quick Knowledge Check

1. Why does `unset HISTFILE` alone not clean up a session that already happened?
   - A) It does clean up past sessions too  B) It only prevents *future* commands in the current session from being written to disk — history already on disk is unaffected  C) It deletes all logs  D) It requires root

2. Why edit `auth.log` with `sed -i '/pattern/d'` instead of truncating the whole file?
   - A) No real reason  B) Selectively removing only the relevant lines leaves the rest of the log looking normal, while an empty/truncated log file is itself an obvious red flag  C) sed is faster  D) Truncating doesn't work on log files

3. What does `wtmp` track that `auth.log` doesn't fully overlap with?
   - A) Nothing, they're identical  B) `wtmp` is a separate binary login/logout record read by tools like `last`, independent of the text-based syslog  C) wtmp only tracks failed logins  D) wtmp is encrypted

4. What is "timestomping"?
   - A) Deleting a file  B) Altering a file's timestamps (e.g. with `touch -r`) to make it blend in with legitimate, older files  C) Compressing a file  D) A type of log rotation

5. What does `shred` do before deleting a file that `rm` does not?
   - A) Nothing different  B) Overwrites the file's data on disk (multiple passes by default) before unlinking it, making recovery much harder  C) Encrypts the file  D) Backs up the file first

---

## Cleanup

```bash
exit
cd labs/phase5-covering-tracks/lab11-log-anti-forensics
docker compose down
```

---

## Summary

Today you learned to:
✓ Control what does and doesn't get written to bash history
✓ Selectively edit a text log file to remove specific evidence
✓ Clear binary login records (`wtmp`)
✓ Timestomp a file to blend it in with legitimate ones
✓ Securely delete a file with `shred` instead of `rm`
✓ Verify your own cleanup work programmatically

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
