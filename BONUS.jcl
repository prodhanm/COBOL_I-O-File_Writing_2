//BONUS JOB 0000,'BONUS    ',MSGCLASS=Q,MSGLEVEL=(1,1),
//  NOTIFY=&SYSUID,CLASS=A,REGION=0M
//*
//COMPILE EXEC IGYWCL,PARM=(OFFSET,NOLIST,ADV),
//  PGMLIB='&&GOSET',GOPGM=BONUS
//COBOL.SYSIN   DD  DSN=FILE_IO(BONUS),DISP=SHR
//COBOL.SYSLIB  DD  DSN=TSOBA16.ONLINE.LOADLIB,DISP=SHR
//*
//STEP2     EXEC PGM=BONUS
//STEPLIB   DD DSN=*.COMPILE.LKED.SYSLMOD,DISP=SHR
//INBONUS   DD DSN=FILE_IO.DATA(INBONUS),DISP=SHR
//OUTBONUS  DD SYSOUT=*
//BADBONUS  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//*