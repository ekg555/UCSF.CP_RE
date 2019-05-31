: tip from https://www.tenforums.com/tutorials/44101-unzip-files-zipped-folder-windows-10-a.html
: reference https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/expand-archive?view=powershell-5.1
set mypath=%cd%
echo %mypath%

IF NOT EXIST %mypath%\Signed_Docs\ (
	mkdir Signed_Docs)

set destpath=%mypath%\Signed_Docs\


:string concat w/ spaces
:set "nf=%mypath%\New Folder"
:cd %nf%
:dir

: EXTRACT ALL .ZIP to SIGNED-DOCS (OVERWRITES DUPLICATES)
forfiles /m *.zip /c "cmd /c PowerShell Expand-Archive -Force -Path @path -DestinationPath %destpath%" 
: forfiles /s to recurse into subdir.

cd %destpath%

:REPLACE ("_" -> " ") & (".xls" -> "")
: ----------------------------------------------------
@echo off
Setlocal enabledelayedexpansion

Set "Pattern=_"
Set "Replace= "

For %%a in (*.pdf) Do (
    Set "File=%%~a"
    Ren "%%a" "!File:%Pattern%=%Replace%!"
)

Set "Pattern=.xls"
Set "Replace="

For %%a in (*.pdf) Do (
    Set "File=%%~a"
    Ren "%%a" "!File:%Pattern%=%Replace%!"
)
@echo on
: -----------------------------------------------------
del Summary.pdf

: get list of files (.pdf MINUS "Summary.pdf")
dir /b /s *.pdf | findstr /v /i "Summary.pdf" > manifest.txt 


pause
