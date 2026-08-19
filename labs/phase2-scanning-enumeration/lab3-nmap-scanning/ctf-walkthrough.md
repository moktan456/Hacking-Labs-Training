# Lab 3 — CTF Walkthrough (Answer Key)

## Step 1: Confirm anonymous FTP

```bash
nmap --script ftp-anon 10.10.3.11
```

Confirms anonymous login is allowed.

## Step 2: user.txt

```bash
ftp 10.10.3.11
# Name: anonymous
# Password: (blank/anonymous)
cd pub
get user.txt
quit
cat user.txt
```

Flag: `flag{lab3_anon_ftp_reader}`

## Step 3: root.txt (hidden directory)

A plain `ls` inside `pub/` won't show dotfiles/dot-directories. List everything:

```bash
ftp 10.10.3.11
# Name: anonymous
cd pub
ls -a
cd .backup
get root.txt
quit
cat root.txt
```

Or do it in one shot with nmap's script, which lists hidden entries too:

```bash
nmap -p21 --script ftp-anon 10.10.3.11
```

Flag: `flag{lab3_hidden_dir_enumeration}`

## Lesson

A default directory listing hides dotfiles — thorough enumeration means explicitly checking for hidden files and directories, not stopping at the first listing you see.
