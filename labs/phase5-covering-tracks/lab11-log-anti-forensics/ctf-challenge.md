# Lab 11 — CTF Challenge

**No hints below.**

## Objective

Two starting flags are given immediately (root access is granted for this lab — the challenge isn't getting in). The real objective:

- Generate real evidence of your activity (a failed login, a successful login, command history, a dropped file).
- Remove or falsify every trace of it.
- Run `/root/verify.sh` on the target. Passing all four checks reveals a bonus flag.

## Rules

- Target: `10.10.11.10` only
- Attack from: `10.10.11.2` (`lab11-attacker`) — the verification script checks specifically for this IP
- Flag format: `flag{...}`

Good luck.
