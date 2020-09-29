REM *** Zindex Development 2010-01-18 - Tlf 51520000 lasse@zindex.dk
REM *** BACKUP script.
REM *** Sender daglig BACKUP ud til USB efter at have fundet nøglen, og overskriver eksisterende BACKUP
REM *** Den leder efter \BACKUP\ på drevne for at finde den rigtige USB nøgle

Set drev=0


IF EXIST D:\BACKUP\NUL SET drev=d
IF EXIST e:\BACKUP\NUL SET drev=e
IF EXIST f:\BACKUP\NUL SET drev=f
IF EXIST g:\BACKUP\NUL SET drev=g
IF EXIST h:\BACKUP\NUL SET drev=h

IF %drev%==0 goto Fejl


:BACKUP
C:\WINDOWS\system32\ntBACKUP.exe BACKUP "@C:\BACKUP\dagligt.bks" /n "Daglig.bkf created %DATE%" /d "Set created 18-01-2010 at 15:00" /v:yes /r:no /rs:no /hc:off /m normal /j "BACKUP" /l:s /f "%drev%:\Daglig.bkf"




hutdown -s

quit

:Fejl
Echo Off
CLS
Echo *********************************************************************
Echo * ADVARSEL! Nattens backup er ikke koert, da der ikke kunne findes  *
Echo * USB noegle der er klargjort til denne backuptype                  *
Echo * Indsaet en brugbar noegle, eller kontakt Zindex paa tlf. 51520000 *
Echo *********************************************************************
Pause