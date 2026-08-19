# Lab 1: Packet Capture & Traffic Analysis
## Phase 1 — Reconnaissance | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** every command below targets containers started by this lab's own `docker-compose.yaml`. Don't point these tools anywhere else.

**What you're practicing:** capturing live traffic, saving it as a `.pcap`, and reading it back — both visually in Wireshark and on the command line with `tshark`. This is the foundation skill for the rest of reconnaissance: you can't analyze traffic you didn't capture.

---

## Setup (5 minutes)

```bash
# From the repo root — only needed once across all labs
make build-base

# Start this lab
cd labs/phase1-reconnaissance/lab1-packet-capture
docker compose up -d

# Enter the attacker container
docker exec -it lab1-attacker bash

# Verify connectivity
ping -c 2 10.10.1.10
```

**Check:** Do you see ping replies? ✓ Yes ✓ No

Open a browser to `http://localhost:14501` — this is the Wireshark GUI. Leave it open in a tab; you'll come back to it in Part 2.

---

## Part 1: Capturing Live Traffic with tcpdump (15 minutes)

> **Why capture on the attacker container?** A Docker bridge network only lets a container see traffic to and from itself — it can't passively observe two *other* containers talking. So this exercise captures around the attacker's own connection to the target, the same way you'd capture from a network tap or an in-path device on a real engagement.

### Exercise 1.1: Start a background capture

```bash
# -i eth0 = capture on the attacker's network interface
# -w      = write raw packets to a file instead of printing them
tcpdump -i eth0 -w /captures/telnet-session.pcap host 10.10.1.10 &
```

**Question:** What does the `host 10.10.1.10` filter do to what tcpdump records?

_________________________________

### Exercise 1.2: Generate traffic to capture

While the capture runs in the background, connect to the target and log in:

```bash
telnet 10.10.1.10
# login: netadmin
# password: cleartext123
cat user.txt
exit
```

**Did you retrieve a flag?** ✓ Yes ✓ No — write it here: _________________________________

### Exercise 1.3: Stop the capture

```bash
# Bring the background job to the foreground and stop it
fg
# press Ctrl+C

ls -la /captures/
```

**How large is `telnet-session.pcap` in bytes?** _____

---

## Part 2: Visual Analysis in Wireshark (20 minutes)

### Exercise 2.1: Open the capture

In the Wireshark GUI tab (`http://localhost:14501`), use **File → Open** and browse to `/captures/telnet-session.pcap`.

### Exercise 2.2: Filter to just the Telnet conversation

In the display filter bar, type:

```
telnet
```

**How many packets matched the filter?** _____

### Exercise 2.3: Follow the TCP Stream

Right-click any Telnet packet → **Follow → TCP Stream**.

**Write down what you can read in the stream:**

- Username: _________________________________
- Password: _________________________________

**Question:** Telnet sends every keystroke as a separate packet. Why does that make the Follow Stream view so much easier to read than scrolling packet-by-packet?

_________________________________

**Question:** What would you have seen instead if this had been an SSH session rather than Telnet?

_________________________________

---

## Part 3: Command-Line Analysis with tshark (15 minutes)

Wireshark's GUI and `tshark` read the same capture files — `tshark` is what you use when there's no GUI available (a remote server, a script, a CI pipeline).

### Exercise 3.1: List packets from the command line

```bash
tshark -r /captures/telnet-session.pcap -Y telnet
```

**Question:** What does `-Y` do, compared to `-r` alone?

_________________________________

### Exercise 3.2: Extract specific fields

```bash
tshark -r /captures/telnet-session.pcap -T fields -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport
```

**Fill in one row you observed:**

| Source IP | Dest IP | Source Port | Dest Port |
|-----------|---------|--------------|------------|
|           |         |              |            |

---

## Part 4: Recognizing Scan Traffic in a Capture (15 minutes)

Reconnaissance isn't just about reading credentials — you also need to recognize what an active scan looks like on the wire, since you'll be running (and later, defending against) exactly this traffic.

### Exercise 4.1: Capture a port scan

```bash
tcpdump -i eth0 -w /captures/scan.pcap host 10.10.1.10 &
nmap -sS 10.10.1.10
fg
# Ctrl+C to stop the capture
```

### Exercise 4.2: Count the SYN packets

```bash
tshark -r /captures/scan.pcap -Y "tcp.flags.syn==1 && tcp.flags.ack==0" | wc -l
```

**How many SYN-only packets were sent?** _____

**Question:** In the capture, which ports got a `SYN, ACK` back, and which got a `RST, ACK`? What does each response tell you about the port's state?

_________________________________

Open `scan.pcap` in the Wireshark GUI and look at the **Statistics → Conversations** view.

**Question:** How would a very large number of SYN packets to sequential ports, all from one source IP, in a few seconds, look to someone monitoring this traffic?

_________________________________

---

## Quick Knowledge Check

1. What flag tells tcpdump to write captured packets to a file instead of printing them?
   - A) `-r`  B) `-w`  C) `-Y`  D) `-i`

2. Which Wireshark feature reconstructs an entire TCP conversation into readable text?
   - A) Statistics  B) Follow TCP Stream  C) Protocol Hierarchy  D) Expert Info

3. What TCP flag combination indicates an open port in response to a SYN scan?
   - A) RST, ACK  B) SYN, ACK  C) FIN, ACK  D) SYN only

4. Why is Telnet traffic trivial to read in a packet capture, while SSH traffic isn't?
   - A) Telnet uses UDP  B) Telnet is unencrypted  C) SSH uses fewer packets  D) There's no difference

5. What does the tshark flag `-Y` apply?
   - A) A capture filter (limits what's captured)  B) A display filter (limits what's shown from an existing capture)  C) An output format  D) A write filter

---

## Cleanup

```bash
exit
cd labs/phase1-reconnaissance/lab1-packet-capture
docker compose down
```

---

## Summary

Today you learned to:
✓ Capture live traffic with tcpdump
✓ Open and filter a `.pcap` in Wireshark's GUI
✓ Use Follow TCP Stream to reconstruct a plaintext session
✓ Extract fields from a capture with tshark on the command line
✓ Recognize SYN-scan traffic patterns in a packet capture

---

## Optional: CTF Challenge

Once you've completed the exercises above, try the optional flag-capture challenge.

See **[ctf-challenge.md](./ctf-challenge.md)** for objectives.

Two flags to find: `user.txt` and `root.txt` — flag format `flag{...}`. No hints. Check your work against **[ctf-walkthrough.md](./ctf-walkthrough.md)** when you're done or stuck.
