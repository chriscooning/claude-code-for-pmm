@echo off
REM Claude Code for PMM Setup Script - Windows Wrapper
REM This script detects PowerShell and runs the setup.ps1 script

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error: PowerShell is not installed or not in PATH.
    echo Please install PowerShell 5.1 or later.
    echo.
    echo You can download PowerShell from:
    echo https://aka.ms/powershell
    echo.
    pause
    exit /b 1
)

REM Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

REM Try to run with bypass execution policy
powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup.ps1"
set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% NEQ 0 (
    echo.
    echo Setup failed with error code %EXIT_CODE%
    echo.
    echo If you see an execution policy error, you may need to set the execution policy.
    echo Run this command in PowerShell as Administrator:
    echo.
    echo   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    echo.
    echo Or run this command to allow scripts for the current session only:
    echo.
    echo   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
    echo.
    echo Then try running setup.bat again.
    echo.
    pause
    exit /b %EXIT_CODE%
)

exit /b 0
