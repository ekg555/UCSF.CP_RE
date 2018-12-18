REM 1) Get filenames in current directory (filter out any .txt / .bat / .csv)
dir /b | findstr /v /i "\.txt$" | findstr /v /i "\.bat$" | findstr /v /i "\.csv$"  > filelist.csv

REM  REN "*11.16.2018.xls" *..

pause