# Lab 2 — CTF Walkthrough (Answer Key)

## Flag 1: DNS TXT record via zone transfer

```bash
dig @10.10.2.5 cybercorp.lab AXFR
```

Look for the `_flag.cybercorp.lab. TXT` line in the output:

```
flag{lab2_axfr_zone_leak}
```

## Flag 2: Page-source clue on the web server

```bash
curl -s http://10.10.2.10 | grep -i backup
```

Reveals an HTML comment pointing at `/backup.txt`:

```bash
curl -s http://10.10.2.10/backup.txt
```

```
flag{lab2_html_comment_led_to_backup}
```

## Lesson

Neither flag required exploiting anything — one came from a DNS server handing over its whole zone to any client that asked, the other from a developer leaving a comment (and a file) in production that was never meant to ship. Recon wins are often just "someone left the door unlocked," not clever exploitation.
