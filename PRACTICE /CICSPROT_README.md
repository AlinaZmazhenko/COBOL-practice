# CICSPROTECT — Secure COBOL CICS Gateway

**CICSPROT.CBL** simulates a secure gateway in COBOL using CICS (Customer Information Control System). It enforces user authentication, access logging, and transaction role control, all within a mainframe-style architecture.
Purpose
This project demonstrates how modern cybersecurity principles can be integrated into legacy transactional environments without a full rewrite of COBOL+CICS systems.

 Features
- 3-attempt login restriction
- Role-based command access (view/edit)
- CICS file logging with timestamp
- Input received via BMS maps (`LOGIN`, `MENU`)
- Action recorded in `ACCESSLOG` (VSAM or flat file)

 Example Setup
- User: `SECURE`
- Password: `CICS123`
- Actions: `VIEW` or `EDIT`

  Use Case
  Legacy systems still power U.S. banking, insurance, and public-sector infrastructure. This demo reflects how to modernize access control and monitoring in those environments.

   Structure
- `CICSPROT.CBL` — Main COBOL CICS module
- `LOGIN.MAP`, `MENU.MAP` — Screens for input
- `SECURITY.md` — Threat model & implementation
- `ACCESSLOG` — Output file (writeable by CICS)
