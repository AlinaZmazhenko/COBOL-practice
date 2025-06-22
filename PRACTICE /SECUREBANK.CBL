       IDENTIFICATION DIVISION.
       PROGRAM-ID. SECUREBANK.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT LOGFILE ASSIGN TO "logfile.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD LOGFILE.
       01 LOG-RECORD         PIC X(100).

       WORKING-STORAGE SECTION.
       01 USERNAME           PIC X(20) VALUE SPACES.
       01 PASSWORD           PIC X(20) VALUE SPACES.
       01 CORRECT-PASS       PIC X(20) VALUE "Secure123".
       01 ATTEMPTS           PIC 9     VALUE 0.
       01 LOGIN-ALLOWED      PIC X     VALUE "Y".

       01 AMOUNT             PIC 9(5)V99 VALUE 0.00.
       01 MAX-AMOUNT         PIC 9(5)V99 VALUE 10000.00.
       01 AMOUNT-STRING      PIC X(10).
       01 INVALID-SYMBOL     PIC X VALUE SPACE.
       01 WS-DATE.
          05 WS-YEAR         PIC 9(4).
          05 WS-MONTH        PIC 99.
          05 WS-DAY          PIC 99.
       01 DATE-STR           PIC X(10).
       01 ACTION-DESC        PIC X(50).

       PROCEDURE DIVISION.
       MAIN-SECTION.
           OPEN OUTPUT LOGFILE
           DISPLAY "WELCOME TO SECUREBANK SYSTEM"
           PERFORM LOGIN-PROCESS
           IF LOGIN-ALLOWED = "N"
               DISPLAY "TOO MANY ATTEMPTS. ACCESS DENIED."
               GO TO END-PROGRAM
           END-IF

           DISPLAY "ENTER TRANSACTION AMOUNT (MAX $10,000): "
           ACCEPT AMOUNT-STRING
           PERFORM SANITIZE-INPUT
           IF INVALID-SYMBOL = "Y"
               DISPLAY "INVALID CHARACTERS DETECTED. OPERATION BLOCKED."
               MOVE "Injection attempt blocked." TO ACTION-DESC
               PERFORM LOG-ACTION
               GO TO END-PROGRAM
           END-IF

           MOVE FUNCTION NUMVAL(AMOUNT-STRING) TO AMOUNT
           IF AMOUNT > MAX-AMOUNT
               DISPLAY "AMOUNT EXCEEDS LIMIT. TRANSACTION DENIED."
               MOVE "Amount over limit denied." TO ACTION-DESC
           ELSE
               DISPLAY "TRANSACTION APPROVED FOR $" AMOUNT
               MOVE "Transaction approved." TO ACTION-DESC
           END-IF

           PERFORM LOG-ACTION

       END-PROGRAM.
           CLOSE LOGFILE
           DISPLAY "SESSION ENDED."
           STOP RUN.

       LOGIN-PROCESS.
           PERFORM UNTIL LOGIN-ALLOWED = "N" OR PASSWORD = CORRECT-PASS
               DISPLAY "ENTER USERNAME: "
               ACCEPT USERNAME
               DISPLAY "ENTER PASSWORD: "
               ACCEPT PASSWORD
               ADD 1 TO ATTEMPTS
               IF PASSWORD NOT = CORRECT-PASS
                   DISPLAY "INVALID PASSWORD. TRY AGAIN."
                   IF ATTEMPTS >= 3
                       MOVE "N" TO LOGIN-ALLOWED
                   END-IF
               END-IF
           END-PERFORM.

       SANITIZE-INPUT.
           MOVE "N" TO INVALID-SYMBOL
           INSPECT AMOUNT-STRING TALLYING AMOUNT FOR CHARACTERS ";--*DROP"
           IF AMOUNT > 0
               MOVE "Y" TO INVALID-SYMBOL
           END-IF.

       LOG-ACTION.
           ACCEPT WS-DATE FROM DATE YYYYMMDD
           STRING WS-YEAR DELIMITED BY SIZE "/" WS-MONTH "/" WS-DAY
               INTO DATE-STR
           STRING DATE-STR " - " USERNAME " - " ACTION-DESC
               DELIMITED BY SIZE INTO LOG-RECORD
           WRITE LOG-RECORD.
