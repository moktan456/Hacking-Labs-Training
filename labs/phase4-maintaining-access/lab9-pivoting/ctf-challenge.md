# Lab 9 — CTF Challenge

**No hints below.**

## Objective

Three flags, only reachable by pivoting through `lab9-pivot` (10.10.9.10):

1. `user.txt` on the pivot host itself
2. A flag on the internal web server (10.10.90.20) — unreachable without a tunnel
3. A flag in the internal database (10.10.90.21) — unreachable without a tunnel

## Rules

- You can only initiate connections from `lab9-attacker`
- The internal network (`10.10.90.0/24`) has no route to it except through the pivot
- Flag format: `flag{...}`

Good luck.
