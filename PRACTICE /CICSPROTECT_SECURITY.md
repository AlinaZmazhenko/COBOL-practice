This module addresses security risks common to legacy COBOL CICS applications by introducing basic protections without altering core architecture.

Implemented Measures

 1. Login Protection
- Users have 3 attempts to authenticate
- Failed attempts are logged with timestamps

 2. Role-Controlled Access
- Input via MENU screen restricted to approved commands only
- Session tied to valid user credentials

 3. CICS Logging
- All actions (view/edit/failed login) written to file (`ACCESSLOG`)
- Each log includes user ID, action, and timestamp

 Risks Addressed

- Credential stuffing (via attempt limiter)
- Command injection (input-controlled MAP fields)
- Lack of auditability (resolved with logs)

 Suggestions for Expansion

- Encrypt logs and credentials
- Implement multi-user sessions
- Integrate with external log aggregator (SIEM-like)
- Add user permission profiles (admin/readonly)

This project reflects a transitional security model for real-world COBOL systems without full rewrite, ideal for high-stakes environments like banking or healthcare.
