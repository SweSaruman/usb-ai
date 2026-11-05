@echo off
setlocal
cd /d "%~dp0"

echo Kontrollerar filernas integritet ...
call "%~dp0verifiera.bat"
if errorlevel 1 (
    echo Integritetskontrollen misslyckades. Anvand verifiera.bat for detaljer.
    pause
    exit /b 1
)

if "%PROCESSOR_ARCHITECTURE%"=="ARM64" (
    set BIN=bin\win-arm64
) else (
    set BIN=bin\win-x64
)

set MODEL=
for %%f in ("%~dp0models\*.gguf") do set MODEL=%%f
if "%MODEL%"=="" (
    echo Ingen modell hittades i models\. Kor forbered.bat forst.
    pause
    exit /b 1
)

echo Startar modellen. Det kan ta en stund att lasa in den ...
start "" "%~dp0%BIN%\llama-server.exe" -m "%MODEL%" --host 127.0.0.1 --port 8080 --path "%~dp0app" -c 4096 --no-warmup

timeout /t 5 /nobreak >nul
start "" "http://127.0.0.1:8080/rollspel.html"
exit /b 0
