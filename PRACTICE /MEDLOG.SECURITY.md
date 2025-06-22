

 MEDLOG: Security Features

This document outlines the basic security elements implemented in the MEDLOG COBOL project, and the risks it addresses.

 Implemented Features

 1. Authentication Control
- Users are required to log in with a username/password.
- Login is limited to 3 failed attempts to prevent brute-force access.

 2. Role-Based Access
- Two roles: `doctor` and `guest`.
- Doctors can edit/view records; guests are restricted to view-only.
- Prevents unauthorized edits.

 3. Audit Logging
- Every action is written to `ACCESS_LOG.TXT` with timestamp.
- Ensures accountability and traceability in data access.

 Threats Addressed
- Unauthorized data modification
- Lack of access logs
- Unlimited brute-force login attempts
- Lack of role separation

  Limitations
- No encryption of passwords
- Logs are plain text
- No multi-user session support

  Extension Ideas
- Store users in an external file or DB
- Integrate hashed password handling
- Add support for session expiration or token validation
- Forward logs to a SIEM-compatible system
