# SecureBank COBOL

SecureBank COBOL is a legacy-style banking module developed in the COBOL programming language with integrated basic cybersecurity features. This project simulates a realistic authentication and transaction scenario common in financial mainframe systems still used across the public and private sectors.

Purpose
The project is intended to:

- Demonstrate the implementation of secure transaction logic in COBOL
- Simulate password authentication with limited login attempts
- Perform input sanitization to prevent simple injection-style attacks
- Validate transaction amounts against preset thresholds
- Log all critical user actions for traceability

It provides a simplified example of how legacy COBOL applications can be hardened against modern threats without full architectural overhauls.

  Security Features

- **Limited Login Attempts**: User accounts are blocked after 3 incorrect password entries.
- **Transaction Thresholds**: Transfers above $10,000 are denied and logged.
- **Input Sanitization**: Detects potentially malicious characters such as `;`, `--`, `*`, `DROP`.
- **Audit Logging**: Each user action is written to a log file with a timestamp for traceability.


