       IDENTIFICATION DIVISION.
       PROGRAM-ID. CICSPROT.
       AUTHOR. ALINA ZMAZHENKO.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 USER-ID          PIC X(10).
       01 PASSWORD         PIC X(10).
       01 AUTH-STATUS      PIC X VALUE 'N'.
       01 ATTEMPT-COUNT    PIC 9 VALUE 0.
       01 MAX-ATTEMPTS     PIC 9 VALUE 3.
       01 TRANS-ACTION     PIC X(20).
       01 LOG-MESSAGE      PIC X(100).
       01 WS-DATE          PIC X(10).
       01 WS-TIME          PIC X(8).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           EXEC CICS ASKTIME ABSTIME(WS-TIME) END-EXEC
           EXEC CICS FORMATTIME ABSTIME(WS-TIME)
               MMDDYY(WS-DATE) TIME(WS-TIME) END-EXEC

           PERFORM AUTHENTICATE-USER
           IF AUTH-STATUS = 'Y'
               PERFORM PROCESS-MENU
           ELSE
               PERFORM LOG-FAILED-ACCESS
               EXEC CICS RETURN END-EXEC.

       AUTHENTICATE-USER.
           PERFORM UNTIL AUTH-STATUS = 'Y' OR ATTEMPT-COUNT >= MAX-ATTEMPTS
               EXEC CICS RECEIVE MAP('LOGIN') MAPSET('LOGINSET')
                    INTO(USER-ID) END-EXEC
               EXEC CICS RECEIVE MAP('LOGIN') MAPSET('LOGINSET')
                    INTO(PASSWORD) END-EXEC
               IF USER-ID = 'SECURE' AND PASSWORD = 'CICS123'
                   MOVE 'Y' TO AUTH-STATUS
               ELSE
                   ADD 1 TO ATTEMPT-COUNT
           END-PERFORM.

       PROCESS-MENU.
           EXEC CICS SEND MAP('MENU') MAPSET('MENUSET') ERASE END-EXEC
           EXEC CICS RECEIVE MAP('MENU') MAPSET('MENUSET')
               INTO(TRANS-ACTION) END-EXEC
           IF TRANS-ACTION = 'VIEW'
               DISPLAY "Accessing secure records..."
               PERFORM LOG-ACTION
           ELSE IF TRANS-ACTION = 'EDIT'
               DISPLAY "Editing records... Done."
               PERFORM LOG-ACTION
           ELSE
               DISPLAY "Invalid action."

       LOG-ACTION.
           STRING WS-DATE DELIMITED BY SIZE
                  " | " USER-ID " | " TRANS-ACTION
                  INTO LOG-MESSAGE
           EXEC CICS WRITE FILE('ACCESSLOG')
                FROM(LOG-MESSAGE)
                LENGTH(LENGTH OF LOG-MESSAGE) END-EXEC.

       LOG-FAILED-ACCESS.
           STRING WS-DATE DELIMITED BY SIZE
                  " | FAILED ATTEMPT by " USER-ID
                  INTO LOG-MESSAGE
           EXEC CICS WRITE FILE('ACCESSLOG')
                FROM(LOG-MESSAGE)
                LENGTH(LENGTH OF LOG-MESSAGE) END-EXEC.
