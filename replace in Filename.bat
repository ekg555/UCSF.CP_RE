:REPLACE ("_" -> " ") & (".xls" -> "")
@echo off
Setlocal enabledelayedexpansion

Set "Pattern=_"
Set "Replace= "

For %%a in (*.pdf) Do (
    Set "File=%%~a"
    Ren "%%a" "!File:%Pattern%=%Replace%!"
)
