# Lab 12: Full-Chain Capstone CTF
## Capstone — Student Worksheet

---

## Before We Start

**Lab-only reminder:** only target `10.10.12.0/24`.

**Format note:** this worksheet gives you milestones, not step-by-step commands — you've built every skill you need across Labs 1–11. Use your notes from those labs. If you get stuck for more than 15–20 minutes on a milestone, check `ctf-walkthrough.md` for that step only, then go back to working independently.

---

## Setup

```bash
make build-base
cd labs/capstone/lab12-full-chain-ctf
docker compose up -d
docker exec -it lab12-attacker bash
```

---

## Milestone 1: Reconnaissance & Scanning (Phase 1–2)

Map the network. You have no target list — find every live host and every open port yourself.

**Which tool(s) will you use, and why those specifically for this step?**

_________________________________

**Fill in what you found:**

| Host IP | Open Ports | Services |
|---------|-----------|----------|
|         |           |          |
|         |           |          |
|         |           |          |

---

## Milestone 2: Enumeration (Phase 2)

Each service you found has more to give up than just "it's open."

- The web server has something worth reading in its page source.
- The FTP server allows anonymous access — see what's in there.

**What did the web page tell you?**

_________________________________

**What files did you find on FTP, and what's unusual about one of them?**

_________________________________

---

## Milestone 3: Gaining Access (Phase 3)

One of the FTP files is encrypted. The web page gave you something that looks like it could unlock it.

**What tool decrypts an OpenSSL-encrypted file if you have the passphrase?**

_________________________________

**What did decrypting it reveal?**

_________________________________

**Log in with what you found. Whose account, and what flag did you get?**

_________________________________

---

## Milestone 4: Privilege Escalation (Phase 3/4 boundary)

You're in, but not as root yet. Check what your current user is allowed to run with elevated privileges.

**What command checks what you can run via `sudo` without further evidence of who you are?**

_________________________________

**What did it show, and how does that let you get a root shell?** (If you're not sure how to turn "can run X as root" into "get a shell," search GTFOBins for the binary you found — that's a real, industry-standard reference for exactly this.)

_________________________________

**Root flag:**

_________________________________

---

## Milestone 5 (Bonus): Cover Your Tracks (Phase 5)

Using what you practiced in Lab 11: clear your bash history, remove your entries from `/var/log/auth.log`, and clear `/var/log/wtmp` on whichever host you actually logged into. There's no automated checker this time — you're on your own to verify it properly.

**What did you check to confirm you were actually clean?**

_________________________________

---

## Full Chain Summary

Write a short recon-to-root narrative — the kind of summary you'd put at the top of a real pentest report:

_________________________________

_________________________________

_________________________________

---

## Cleanup

```bash
exit
cd labs/capstone/lab12-full-chain-ctf
docker compose down
```

---

## Congratulations

If you got a root flag, you've now run every phase of the ethical hacking lifecycle end to end, chained together with no hints, using tools you built real competency with across eleven earlier labs.

---

## Optional: Full Walkthrough

Only after you've genuinely tried — see **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
