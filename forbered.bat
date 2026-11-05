@echo off
setlocal
cd /d "%~dp0"

set ARGS=
if /i "%1"=="qwen" set ARGS=-Modell qwen
if /i "%1"=="summor" set ARGS=-Summor

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0forbered.ps1" %ARGS%
pause
