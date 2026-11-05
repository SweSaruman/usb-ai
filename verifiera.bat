@echo off
setlocal
cd /d "%~dp0"

echo Integritetskontroll mot SHA256SUMS.txt ...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0forbered.ps1" -Verifiera
if errorlevel 1 (
    echo MISSLYCKADES: en eller flera filer stammer inte.
    exit /b 1
)
echo Alla filer OK.
exit /b 0
