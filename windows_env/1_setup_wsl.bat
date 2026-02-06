@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

echo ============================================
echo  WSL + Ubuntu + zsh Setup Script
echo ============================================

:: --- Require admin ---
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo ERROR: Run this script as Administrator.
  pause
  exit /b 1
)

:: --- Enable required Windows features ---
echo Enabling Windows features (WSL + Virtual Machine Platform)...
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

:: --- Install WSL kernel & set WSL2 default ---
echo Installing WSL kernel and setting WSL2 as default...
wsl --update
wsl --set-default-version 2

:: --- Install Ubuntu if missing ---
echo Checking for Ubuntu installation...
wsl -l -q | findstr /i "^Ubuntu$" >nul
if %errorlevel% neq 0 (
  echo Ubuntu not found. Installing...
  wsl --install -d Ubuntu
) else (
  echo Ubuntu already installed.
)

echo.
echo If Windows or WSL requests a reboot:
echo   1. Reboot now
echo   2. Re-run this script
echo.

:: --- Attempt zsh setup only if Ubuntu exists ---
wsl -l -q | findstr /i "^Ubuntu$" >nul
if %errorlevel% equ 0 (
  echo Configuring zsh inside Ubuntu...
  wsl -d Ubuntu -- bash -lc "
    if ! command -v zsh >/dev/null 2>&1; then
      sudo apt update &&
      sudo apt install -y zsh curl git &&
      chsh -s \$(which zsh)
    fi
  "
) else (
  echo Skipping Linux setup: Ubuntu not ready yet.
)

echo ============================================
echo Setup stage complete.
echo ============================================
pause