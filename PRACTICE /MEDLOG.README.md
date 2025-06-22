MEDLOG — COBOL Medical Access Control Module

MEDLOG.CBL is a simple COBOL-based prototype simulating user authentication, role-based access control, and audit logging in a legacy-style medical system.

Purpose
The project demonstrates how basic security principles can be integrated into COBOL systems, which are still used in some hospital and insurance infrastructures. It shows how we can:

- Authenticate users with passwords
- Grant access based on user role (doctor vs guest)
- Log all actions (view/edit) in a traceable file

 Security Logic
- Login restricted to 3 attempts
- Doctor has view/edit permissions; guest has view-only
- All actions are timestamped and recorded in `ACCESS_LOG.TXT`

  Structure
- `MEDLOG.CBL` — COBOL source code
- `ACCESS_LOG.TXT` — Log file generated at runtime
- `README.md` — Project overview
- `SECURITY.md` — Threats addressed

 Example Users
- **Username**: `DOCTOR` / Password: `MED123`
- **Username**: `GUEST` / Password: `GUEST`


