goto comment1
REM Format - yyyymmdd_HHMMSS
REM -------------------------------
echo %DATE% %TIME%

REM echo mm = %date:~4,2%
REM echo dd = %date:~7,2%
REM echo yyyy = %date:~10,4%
:comment1

REM timestring = the time w/ leading 0s
REM timestamp = date & time (e.g. 2018.11.27_08.04)
set timestring=%time: =0%
set timestamp=%date:~10,4%.%date:~4,2%.%date:~7,2%_%timestring:~0,2%.%timestring:~3,2%

REM 1) EXCLUDING .txt, .bat, .csv, hidden-files, and directories
REM  /v = filters OUT, /i = non-case sensitive 
REM 2) saves to timestamped csv (e.g. "file_list_2018.11.27_08.04.csv
dir /a-d-h /b | findstr /v /i "\.txt" | findstr /v /i "\.bat" | findstr /v /i "\.csv" >> file_list_%timestamp%.txt
pause
