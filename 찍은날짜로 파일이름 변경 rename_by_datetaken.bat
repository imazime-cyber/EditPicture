@echo off
chcp 65001 >nul
setlocal

set "TARGET=%~dp0"
if not "%~1"=="" set "TARGET=%~1"

if "%TARGET:~-1%"=="\" set "TARGET=%TARGET:~0,-1%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0rename_by_datetaken.ps1" -Folder "%TARGET%"

echo.
pause
