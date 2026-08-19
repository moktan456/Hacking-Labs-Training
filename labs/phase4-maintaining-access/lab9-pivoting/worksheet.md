# Lab 9: Lateral Movement & Pivoting
## Phase 4 — Maintaining Access | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only target this lab's own containers.

**What you're practicing:** using a host you've already gained access to as a relay into a network your own machine can't reach directly — the core "maintaining/expanding access" skill after initial compromise.

---

## Setup (5 minutes)

```bash
cd labs/phase4-maintaining-access/lab9-pivoting
docker compose up -d
docker exec -it lab9-attacker bash
```

### Exercise 0.1: Confirm the internal network is actually unreachable

```bash
ping -c 2 10.10.9.10     # the pivot host - should respond
ping -c 2 10.10.90.20    # an internal target - should NOT respond
```

**Did the internal target respond?** ✓ Yes ✓ No

**Question:** Why can't you reach `10.10.90.20` directly, even though you know its IP address?

_________________________________

---

## Part 1: Establish the Foothold (10 minutes)

### Exercise 1.1: SSH into the pivot host

```bash
ssh pivotuser@10.10.9.10
# password: pivot123
cat user.txt
exit
```

**Flag:** _________________________________

---

## Part 2: Pivot with a Dynamic SOCKS Proxy (25 minutes)

### Exercise 2.1: Open a SOCKS tunnel through the pivot

`-D` turns your SSH connection into a SOCKS proxy — anything you point through it gets relayed via the pivot host's network view, which *does* include the internal subnet.

```bash
ssh -f -N -D 1080 pivotuser@10.10.9.10
# runs in the background (-f), no remote command (-N), SOCKS proxy on local port 1080
```

**Check:** is there now a process listening on `127.0.0.1:1080`? Run `ss -tlnp | grep 1080` to confirm.

### Exercise 2.2: Route traffic through the proxy

`proxychains4` forces any command's network traffic through your SOCKS proxy. Check its config first:

```bash
cat /etc/proxychains/proxychains.conf | tail -5
```

**What proxy and port does it list at the bottom?** _________________________________

Now reach the internal web server *through* the tunnel:

```bash
proxychains4 curl -s http://10.10.90.20
```

**Did you get the internal page back this time?** ✓ Yes ✓ No

**What flag did the page contain?** _________________________________

### Exercise 2.3: Scan the internal subnet through the proxy

```bash
proxychains4 nmap -sT -Pn -p 80,3306 10.10.90.20 10.10.90.21
```

**Question:** Why did this exercise use `nmap -sT` (full TCP connect) instead of `-sS` (SYN scan)? What does routing through a SOCKS proxy via proxychains require of the scan technique?

_________________________________

---

## Part 3: Direct Port Forwarding (15 minutes)

Dynamic proxying (`-D`) is flexible but requires every tool to support SOCKS (via proxychains). For a single specific service, local port forwarding (`-L`) is simpler — it maps one local port straight to one destination through the tunnel, and ordinary tools connect to `localhost` with no special configuration.

### Exercise 3.1: Forward MySQL through the pivot

```bash
ssh -f -N -L 3307:10.10.90.21:3306 pivotuser@10.10.9.10
```

**If the connection below fails immediately** (`Can't connect to server on '127.0.0.1'`), the `-f` flag occasionally backgrounds the process a moment before the forward is fully established. Confirm with `ss -tlnp | grep 3307` — if nothing is listening yet, just re-run the `ssh -L` command above (or drop `-f` and add `&` yourself: `ssh -N -L ... pivotuser@10.10.9.10 &`) and try again.

### Exercise 3.2: Connect as if the database were local

```bash
mysql -h 127.0.0.1 -P 3307 -u appuser -papppass456 --skip-ssl -e "SHOW DATABASES;"
```

**Did it work?** ✓ Yes ✓ No

**Question:** From the perspective of the `mysql` client, is there any difference between this and connecting to a real local database? What does that tell you about how invisible a well-placed pivot can be?

_________________________________

---

## Part 4: Metasploit's Built-In Pivoting (15 minutes)

Metasploit can pivot without a manual SSH tunnel at all, once it has a session on the pivot host — useful when you have a Meterpreter session but not SSH credentials.

### Exercise 4.1: Explore autoroute (conceptual — no live Meterpreter session in this lab)

```bash
msfconsole -q -x "show post" 2>&1 | grep -i autoroute
```

**Question:** In a real engagement, once you have a Meterpreter session on `lab9-pivot`, the module `post/multi/manage/autoroute` adds a route through that session so every other Metasploit module can reach the internal subnet automatically. Compare this to the manual SSH tunnel you just built — what's the tradeoff (setup effort vs. what you get) between the two approaches?

_________________________________

---

## Quick Knowledge Check

1. What does `ssh -D 1080 user@host` create?
   - A) A direct port forward  B) A dynamic SOCKS proxy through the SSH connection  C) A reverse shell  D) A file transfer channel

2. What does `proxychains4` do to a command you prefix it with?
   - A) Runs it faster  B) Forces its network connections through the configured proxy chain  C) Encrypts its output  D) Nothing without root

3. What's the key difference between `-D` (dynamic) and `-L` (local) SSH forwarding?
   - A) No difference  B) `-D` is a general-purpose SOCKS proxy for any destination; `-L` maps one fixed local port to one fixed remote destination  C) `-L` requires root, `-D` doesn't  D) `-D` only works with HTTP

4. Why does scanning through a SOCKS proxy typically require `-sT` instead of `-sS`?
   - A) SYN scans need raw socket access that a SOCKS-proxied connection can't provide — proxied traffic goes through regular TCP connect calls  B) There's no real difference  C) `-sT` is always faster  D) SOCKS doesn't support TCP

5. Why is a Docker `internal: true` network a good stand-in for a segmented internal corporate network?
   - A) It isn't a good comparison  B) It genuinely has no route to the outside except through a host that's bridged into both networks — the same shape as a real segmented network with one gateway/jump host  C) It's slower  D) It only allows UDP

---

## Cleanup

```bash
# Kill any background ssh tunnels first
pkill -f "ssh -f -N" 2>/dev/null
exit
cd labs/phase4-maintaining-access/lab9-pivoting
docker compose down
```

---

## Summary

Today you learned to:
✓ Confirm network segmentation from an attacker's perspective
✓ Establish a foothold via SSH on a dual-homed pivot host
✓ Build a dynamic SOCKS proxy and route tools through it with proxychains4
✓ Set up direct local port forwarding for a single service
✓ Understand how Metasploit's `autoroute` achieves the same goal without manual tunnels

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Three flags across the pivot chain. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
