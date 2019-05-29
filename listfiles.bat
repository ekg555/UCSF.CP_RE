:List All PDFs in O: drive
@echo off
cd /D r:

:dir /B /S 
dir /A:-D /S /B >  ALL_FILES.tab

:findstr /I "\.pdf$" > "C:\Users\ekonagaya\Desktop\ALL_PDFs.tab"
:findstr /I "\.msg$" > "C:\Users\ekonagaya\Desktop\ALL_EMAILs.tab"

echo DONE.
:OPEN ALL_FILES.txt & target-folder
start ALL_FILES.tab
start.

pause

