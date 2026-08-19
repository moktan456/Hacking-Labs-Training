.PHONY: build-base kali \
        run-lab1 run-lab2 run-lab3 run-lab4 run-lab5 run-lab6 \
        run-lab7 run-lab8 run-lab9 run-lab10 run-lab11 run-lab12 \
        stop-all clean-all down-all build-all

LAB1  := labs/phase1-reconnaissance/lab1-packet-capture
LAB2  := labs/phase1-reconnaissance/lab2-osint-recon
LAB3  := labs/phase2-scanning-enumeration/lab3-nmap-scanning
LAB4  := labs/phase2-scanning-enumeration/lab4-web-enumeration
LAB5  := labs/phase2-scanning-enumeration/lab5-service-enumeration
LAB6  := labs/phase3-gaining-access/lab6-password-attacks
LAB7  := labs/phase3-gaining-access/lab7-web-exploitation
LAB8  := labs/phase3-gaining-access/lab8-buffer-overflow
LAB9  := labs/phase4-maintaining-access/lab9-pivoting
LAB10 := labs/phase4-maintaining-access/lab10-persistence
LAB11 := labs/phase5-covering-tracks/lab11-log-anti-forensics
LAB12 := labs/capstone/lab12-full-chain-ctf

ALL_LABS := $(LAB1) $(LAB2) $(LAB3) $(LAB4) $(LAB5) $(LAB6) $(LAB7) $(LAB8) $(LAB9) $(LAB10) $(LAB11) $(LAB12)

# ── Build the shared Kali attacker image (run once before any lab) ──────────
build-base:
	docker build -f base.Dockerfile -t ethical-base .

# ── Run standalone Kali shell (no lab targets needed) ───────────────────────
kali:
	docker run -it --rm --name kali-shell --cap-add=NET_RAW --cap-add=NET_ADMIN --hostname kali ethical-base bash

# ── Start a lab ───────────────────────────────────────────────────────────────
run-lab1:
	cd $(LAB1) && docker compose up -d

run-lab2:
	cd $(LAB2) && docker compose up -d

run-lab3:
	cd $(LAB3) && docker compose up -d

run-lab4:
	cd $(LAB4) && docker compose up -d

run-lab5:
	cd $(LAB5) && docker compose up -d

run-lab6:
	cd $(LAB6) && docker compose up -d

run-lab7:
	cd $(LAB7) && docker compose up -d

run-lab8:
	cd $(LAB8) && docker compose up -d

run-lab9:
	cd $(LAB9) && docker compose up -d

run-lab10:
	cd $(LAB10) && docker compose up -d

run-lab11:
	cd $(LAB11) && docker compose up -d

run-lab12:
	cd $(LAB12) && docker compose up -d

# ── Teardown ─────────────────────────────────────────────────────────────────
stop-all:
	@for lab in $(ALL_LABS); do \
		(cd $$lab && docker compose down 2>/dev/null || true); \
	done

clean-all:
	docker system prune -f

down-all: stop-all clean-all

build-all: build-base
