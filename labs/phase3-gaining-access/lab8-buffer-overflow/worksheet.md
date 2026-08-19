# Lab 8: Exploit Development (Buffer Overflow)
## Phase 3 — Gaining Access | Student Worksheet

---

## Before We Start (2 minutes)

**Lab-only reminder:** only target this lab's own containers (`10.10.8.0/24`).

**What you're practicing:** the classic ret2win stack overflow — the foundational exploit-dev exercise everything else (ROP chains, shellcode injection) builds on. Take your time; this lab has more moving parts than earlier ones.

---

## Setup (5 minutes)

```bash
make build-base
cd labs/phase3-gaining-access/lab8-buffer-overflow
docker compose up -d
docker exec -it lab8-attacker bash
ls /root/tools
```

**Check:** Do you see `vuln` (a compiled binary), `vuln.c`, and `exploit_template.py`? ✓ Yes ✓ No

---

## Part 1: Get a Foothold and Read the Source (15 minutes)

### Exercise 1.1: Initial access via SSH

```bash
ssh lowpriv@10.10.8.11
# password: lowpriv123
cat user.txt
exit
```

**Flag:** _________________________________

### Exercise 1.2: Read the vulnerable source

```bash
cat /root/tools/vuln.c
```

**What's the size of `buffer` in the `vulnerable()` function?** _____

**Question:** `read(0, buffer, 200)` reads up to 200 bytes into a 64-byte buffer, with no bounds check. What happens to the bytes beyond the 64th?

_________________________________

**Question:** `win()` is a complete, callable function in this program — but nothing in `main()` ever calls it. What would have to happen for it to run anyway?

_________________________________

---

## Part 2: Check What Protections Are (Not) In Place (10 minutes)

```bash
pwn checksec /root/tools/vuln
```

**Fill in what you see:**

| Protection | Enabled? |
|------------|----------|
| Stack Canary |  |
| NX (non-executable stack) |  |
| PIE (position-independent executable) |  |

**Question:** This binary was deliberately compiled with `-fno-stack-protector -z execstack -no-pie`. Explain what each of those three flags disables, and why an exploit-dev *practice* target needs them off (while a real production binary should have them all on).

_________________________________

---

## Part 3: Find the Offset with a Cyclic Pattern (25 minutes)

You need to know exactly how many bytes of padding come before you start overwriting the return address. Guessing is unreliable — generate a unique pattern instead.

### Exercise 3.1: Generate a cyclic pattern

```bash
pwn cyclic 100
```

This prints 100 bytes where every 4/8-byte window is unique — whatever ends up in the crash, you can look it up to find the exact offset.

### Exercise 3.2: Crash the local copy under gdb

```bash
gdb /root/tools/vuln
```

Inside gdb:

```
run
```

Paste the cyclic pattern from Exercise 3.1 as input, then press Enter. The program should crash.

```
info registers rip
x/gx $rsp
```

**Question:** `$rip` shows a real, valid address inside `vulnerable()` (the `ret` instruction itself) — not one of your pattern bytes. On x86-64, jumping to a "non-canonical" address (one that doesn't look like a real address at all, which your random-looking pattern bytes almost certainly form) triggers a general-protection fault *at the instruction that attempted the jump*, not at the bogus destination. So where do you actually find the pattern value that was about to become the return address?

_________________________________

`x/gx $rsp` shows exactly that — the corrupted value sitting on the stack that `ret` was about to pop into `$rip`.

**What value did `x/gx $rsp` show?**

_________________________________

### Exercise 3.3: Look up the offset

Exit gdb (`quit`), then:

```bash
pwn cyclic -l <the-value-from-x/gx-$rsp>
```

**What offset did it report?**

_________________________________

**Question:** Why does a cyclic pattern make this reliable, compared to just sending `"AAAA...AAAA"` and guessing how many `A`s caused the crash?

_________________________________

---

## Part 4: Find win()'s Address (10 minutes)

```bash
python3 -c "from pwn import *; e = ELF('/root/tools/vuln'); print(hex(e.symbols['win']))"
```

**What address did you get?**

_________________________________

**Question:** This only gives a reliable, *fixed* address because of one of the protections you checked in Part 2 being off. Which one, and why does it matter?

_________________________________

---

## Part 5: Build and Fire the Exploit (20 minutes)

### Exercise 5.1: Fill in the template

```bash
cp /root/tools/exploit_template.py /root/exploit.py
nano /root/exploit.py
```

Set `OFFSET` to the value from Exercise 3.3 (it should already default to a reasonable value — confirm it matches what you found).

### Exercise 5.2: Run it against the real target

```bash
python3 /root/exploit.py
```

**Did you see the "ACCESS GRANTED" banner?** ✓ Yes ✓ No

`win()` prints a flag directly to your exploit's output the moment it runs — that's your proof of code execution, and it's what you're graded on. It then calls `system("/bin/sh")`.

**What flag did `win()` print?**

_________________________________

**Note:** `system("/bin/sh")` is the simplest possible way to get a shell, but it's not always a *stable* one — because there's no real terminal (TTY) attached, the spawned shell can exit almost immediately once it hits end-of-input, especially over a plain socket like this one. If your shell drops before you can type anything, that's expected with this basic technique, not a mistake you made. (Real payloads often add a PTY-upgrade step for exactly this reason — worth researching on your own if you want to go further.)

---

## Quick Knowledge Check

1. What does a stack canary protect against?
   - A) SQL injection  B) A stack buffer overflow overwriting the return address undetected — the canary value gets checked before the function returns, and a corrupted canary aborts the program  C) Network sniffing  D) Password reuse

2. Why does this lab's binary need PIE disabled for the exploit to work reliably?
   - A) It doesn't matter  B) With PIE on, the binary (and win()'s address) loads at a randomized base address each run, making a hardcoded address in your exploit unreliable  C) PIE only affects libraries  D) PIE prevents the overflow entirely

3. What does a cyclic pattern let you determine?
   - A) The target's IP address  B) The exact byte offset at which your input starts overwriting a specific value (like the return address)  C) The password  D) The compiler version

4. In `read(0, buffer, 200)` writing into a `char buffer[64]`, what's the vulnerability?
   - A) None — this is safe  B) The read length (200) exceeds the buffer size (64) with no bounds check, so excess bytes overwrite adjacent stack memory  C) `read()` is inherently insecure  D) File descriptor 0 is invalid

5. What is `ret2win` shorthand for?
   - A) Returning twice  B) Overwriting a saved return address so execution jumps ("returns") directly to a "win" function that grants access, instead of returning normally  C) A network protocol  D) A password-cracking technique

---

## Cleanup

```bash
exit
cd labs/phase3-gaining-access/lab8-buffer-overflow
docker compose down
```

---

## Summary

Today you learned to:
✓ Read C source to spot an unbounded `read()` into a fixed buffer
✓ Check a binary's protections with `checksec`
✓ Determine an exact stack offset using a cyclic pattern
✓ Locate a target function's address in a non-PIE binary
✓ Build and fire a working ret2win exploit with pwntools

---

## Optional: CTF Challenge

See **[ctf-challenge.md](./ctf-challenge.md)**. Flag format `flag{...}`. Walkthrough: **[ctf-walkthrough.md](./ctf-walkthrough.md)**.
