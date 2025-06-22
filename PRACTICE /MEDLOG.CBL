       IDENTIFICATION DIVISION.
       PROGRAM-ID. MEDLOG.
       AUTHOR. ALINA ZMAZHENKO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCESS-LOG ASSIGN TO "ACCESS_LOG.TXT"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD ACCESS-LOG.
       01 LOG-ENTRY            PIC X(100).

       WORKING-STORAGE SECTION.
       77 USERNAME             PIC X(20).
       77 PASSWORD             PIC X(20).
       77 ROLE                 PIC X(10).
       77 ATTEMPTS             PIC 9 VALUE 0.
       77 MAX-ATTEMPTS         PIC 9 VALUE 3.
       77 ACCESS-GRANTED       PIC X VALUE 'N'.
       77 ACTION               PIC X(30).
       77 TIMESTAMP            PIC X(30) VALUE "2025-06-22".

       PROCEDURE DIVISION.
       OPEN OUTPUT ACCESS-LOG.

       DISPLAY "Welcome to MED-ACCESS System".
       PERFORM AUTHENTICATE-USER.

       IF ACCESS-GRANTED = 'Y'
           DISPLAY "Access Granted to " USERNAME
           PERFORM MEDICAL-ACTIONS
       ELSE
           DISPLAY "Too many failed attempts. Exiting.".

       CLOSE ACCESS-LOG.
       STOP RUN.

       AUTHENTICATE-USER.
           PERFORM UNTIL ACCESS-GRANTED = 'Y' OR ATTEMPTS >= MAX-ATTEMPTS
               DISPLAY "Enter username: " ACCEPT USERNAME
               DISPLAY "Enter password: " ACCEPT PASSWORD
               IF USERNAME = "DOCTOR" AND PASSWORD = "MED123"
                   MOVE "doctor" TO ROLE
                   MOVE "Y" TO ACCESS-GRANTED
               ELSE IF USERNAME = "GUEST" AND PASSWORD = "GUEST"
                   MOVE "guest" TO ROLE
                   MOVE "Y" TO ACCESS-GRANTED
               ELSE
                   DISPLAY "Incorrect credentials."
                   ADD 1 TO ATTEMPTS
           END-PERFORM.

       MEDICAL-ACTIONS.
           IF ROLE = "doctor"
               DISPLAY "Enter action (VIEW/EDIT): " ACCEPT ACTION
               IF ACTION = "EDIT"
                   DISPLAY "Editing record... done."
                   STRING TIMESTAMP DELIMITED BY SIZE
                          " | Doctor edited patient record."
                          INTO LOG-ENTRY
                   WRITE LOG-ENTRY
               ELSE
                   DISPLAY "Viewing patient record..."
                   STRING TIMESTAMP DELIMITED BY SIZE
                          " | Doctor viewed patient record."
                          INTO LOG-ENTRY
                   WRITE LOG-ENTRY
           ELSE
               DISPLAY "Guest access - VIEW only."
               DISPLAY "Viewing record..."
               STRING TIMESTAMP DELIMITED BY SIZE
                      " | Guest viewed patient record."
                      INTO LOG-ENTRY
               WRITE LOG-ENTRY.
