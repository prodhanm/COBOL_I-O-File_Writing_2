        IDENTIFICATION DIVISION.
        PROGRAM-ID. BONUS.
        AUTHOR. REF.
        INSTALLATION. REF COMPANY.
        DATE-WRITTEN. 06/29/2024.
        DATE-COMPILED. 06/29/2024.

        ENVIRONMENT DIVISION.
        INPUT-OUTPUT SECTION.
        FILE-CONTROL.
            SELECT INPUT-BONUS ASSIGN TO INBONUS.
            SELECT OUTPUT-BONUS ASSIGN TO OUTBONUS.
            SELECT BADOUT-BONUS ASSIGN TO BADBONUS.

        DATA DIVISION.
        FILE SECTION.

        FD INPUT-BONUS
            RECORDING MODE IS F
            LABEL RECORDS STANDARD
            RECORD CONTAINS 80 CHARACTERS
            BLOCK CONTAINS 0 RECORDS
            DATA RECORD IS IN-BONUS-REC.
        01 IN-BONUS-REC.
            05 IN-STATE-CODE                    PIC X(2).
            05 IN-LAST-NAME                     PIC X(20).
            05 IN-FIRST-NAME                    PIC X(15).
            05 IN-MID-INIT                      PIC X.
            05 IN-BONUS-AMT                     PIC 9(7)V99.
            05 IN-BONUS-AMT-X                   REDEFINES
                IN-BONUS-AMT                     PIC X(9).
            05 IN-FED-EXEMPT-IND                PIC X.
                88 FED-EXEMPT-IND                   VALUE 'Y' 'N'.
            05 IN-STATE-EXEMPT-IND              PIC X.
                88 STATE-EXEMPT-IND                 VALUE 'Y' 'N'.
            05 IN-FILLER                        PIC X(31).

        FD OUTPUT-BONUS
            RECORDING MODE IS F
            LABEL RECORDS STANDARD
            RECORD CONTAINS 76 CHARACTERS
            BLOCK CONTAINS 0 RECORDS
            DATA RECORD IS OUT-BONUS-REC.
        01 OUT-BONUS-REC.
            05 OUT-STATE-CODE                   PIC X(2).
            05 OUT-LAST-NAME                    PIC X(20).
            05 OUT-FIRST-NAME                   PIC X(15).
            05 OUT-MID-INIT                     PIC X.
            05 OUT-BONUS-AMT                    PIC 9(7)V99 COMP-3.
            05 OUT-FED-EXEMPT-IND               PIC X.
            05 OUT-ST-EXEMPT-IND                PIC X.
            05 OUT-FILLER                       PIC X(31).

        FD BADOUT-BONUS
            RECORDING MODE IS F
            LABEL RECORDS STANDARD
            RECORD CONTAINS 82 CHARACTERS
            BLOCK CONTAINS 0 RECORDS
            DATA RECORD IS BAD-BONUS-REC.
        01 BAD-BONUS-REC.
            05 ERROR-CODE                       PIC X(2).
            05 BAD-STATE-CODE                   PIC X(2).
            05 BAD-LAST-NAME                    PIC X(20).
            05 BAD-FIRST-NAME                   PIC X(15).
            05 BAD-MID-INIT                     PIC X.
            05 BAD-BONUS-AMT                    PIC 9(7)V99.
            05 BAD-FED-EXEMPT-IND               PIC X.
            05 BAD-STATE-EXEMPT-IND             PIC X.
            05 BAD-FILLER                       PIC X(31).

        WORKING-STORAGE SECTION.
        01 FILLER                               PIC C(37) VALUE
            'BEGIN WORKING STORAGE SECTION FOR BONUS'.

        01 W01-ACCUMULATORS.
            05 W01-REC-IN                   PIC S9(4) COMP   VALUE ZERO.
            05 W01-REC-OUT                  PIC S9(4) COMP   VALUE ZERO.
            05 W01-REC-BAD                  PIC S9(4) COMP   VALUE ZERO.

        01 W02-SWITCHES.
            05 W02-IN-EOF-SW               PIC X           VALUE 'N'.
                88 END-OF-INPUT-FILE                       VALUE 'Y'. 
        
        PROCEDURE DIVISION.
        P0100-MAINLINE.

            PERFORM P0200-INITIALIZE        THRU P0299-EXIT

            PERFORM P0300-PROCESS-RECORDS   THRU P0399-EXIT
                UNTIL END-OF-INPUT-FILE

            PERFORM P0400-WRAP-UP           THRU P0499-EXIT

            GOBACK
            .
        P0199-EXIT.
            EXIT.

        P0200-INITIALIZE.

            OPEN INPUT INPUT-BONUS
                 OUTPUT OUTPUT-BONUS
                 OUTPUT BADOUT-BONUS

            PERFORM P0900-READ-INPUT       THRU P0999-EXIT
            
            IF END-OF-INPUT-FILE
                DISPLAY 'BONUS - NO INPUT TO PROCESS'
            END-IF 

            .
        P0299-EXIT.
            EXIT.

        P0300-PROCESS-INPUT.

            INITIALIZE OUT-BONUS-REC
            INITIALIZE BAD-BONUS-REC

            IF IN-STATE-CODE = SPACES
                MOVE '01' TO ERROR-CODE
                PERFORM P0700-WRITE-BADOUT   THRU P0799-EXIT
                ELSE
            IF IN-LAST-NAME = SPACES
                MOVE '02' TO ERROR-CODE
                PERFORM P0700-WRITE-BADOUT   THRU P0799-EXIT
                ELSE
            IF IN-FIRST-NAME = SPACES
                MOVE '03' TO ERROR-CODE
                PERFORM P0700-WRITE-BADOUT   THRU P0799-EXIT
                ELSE
            IF IN-BONUS-AMT NOT NUMERIC
                MOVE '04' TO ERROR-CODE
                PERFORM P0700-WRITE-BADOUT   THRU P0799-EXIT
                ELSE
            IF NOT FED-EXEMPT-IND
                MOVE '05' TO ERROR-CODE
                PERFORM P0700-WRITE-BADOUT   THRU P0799-EXIT
                ELSE
            IF NOT STATE-EXEMPT-IND
                MOVE '06' TO ERROR-CODE
                PERFORM P0700-WRITE-BADOUT   THRU P0799-EXIT
                ELSE
                PERFORM P0600-WRITE-OUTPUT   THRU P0699-EXIT.

                PERFORM P0900-READ-INPUT     THRU P0999-EXIT
            .
        P0399-EXIT.
            EXIT.
        
        P0400-WRAP-UP.

            CLOSE INPUT-BONUS
                  OUTPUT-BONUS
                  
            DISPLAY 'TOTAL RECORDS READ = ' W01-REC-IN
            DISPLAY 'TOTAL GOOD RECORDS = ' W01-REC-OUT
            DISPLAY 'TOTAL BAD RECORDS = ' W01-REC-BAD

            IF W01-REC-IN = (W01-REC-OUT + W01-REC-BAD)
                MOVE +0 TO RETURN-CODE
            ELSE
                DISPLAY 'BONUS - RECORD COUNT OUT OF BALANCE'
                MOVE +99 TO RETURN-CODE
            

            .
        P0499-EXIT.
            EXIT.

        P0600-WRITE-OUTPUT.

            MOVE IN-STATE-CODE          TO OUT-STATE-CODE
            MOVE IN-LAST-NAME           TO OUT-LAST-NAME
            MOVE IN-FIRST-NAME          TO OUT-FIRST-NAME
            MOVE IN-MID-INIT            TO OUT-MID-INIT
            MOVE IN-BONUS-AMT           TO OUT-BONUS-AMT
            MOVE IN-FED-EXEMPT-IND      TO OUT-FED-EXEMPT-IND
            MOVE IN-STATE-EXEMPT-IND    TO OUT-ST-EXEMPT-IND
            MOVE IN-FILLER              TO OUT-FILLER

            WRITE OUT-BONUS-REC
            ADD +1 TO W01-REC-OUT
            .
        P0699-EXIT.
            EXIT.

        P0700-WRITE-BADOUT.

            MOVE IN-STATE-CODE          TO BAD-STATE-CODE
            MOVE IN-LAST-NAME           TO BAD-LAST-NAME
            MOVE IN-FIRST-NAME          TO BAD-FIRST-NAME
            MOVE IN-MID-INIT            TO BAD-MID-INIT
            MOVE IN-BONUS-AMT           TO BAD-BONUS-AMT
            MOVE IN-FED-EXEMPT-IND      TO BAD-FED-EXEMPT-IND
            MOVE IN-STATE-EXEMPT-IND    TO BAD-STATE-EXEMPT-IND
            MOVE IN-FILLER              TO BAD-FILLER

            WRITE BAD-BONUS-REC
            ADD +1 TO W01-REC-BAD
            .
        P0799-EXIT.
            EXIT.

        P0900-READ-INPUT.

            READ INPUT-BONUS
                AT END
                    MOVE 'Y' TO W02-IN-EOF-SW
                NOT AT END
                    ADD +1 TO W01-REC-IN
            END-READ

            .
        P0999-EXIT.
            EXIT.
