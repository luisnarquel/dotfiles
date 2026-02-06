@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

echo Installing JetBrains Mono Nerd Font...
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run this script as Administrator.
    pause
    exit /b 1
)

set FONT_NAME=JetBrainsMono
set ZIP_URL=https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
set TEMP_DIR=%TEMP%\jbmono_nf
set FONT_DIR=C:\Windows\Fonts

:: Cleanup
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

echo Downloading font...
powershell -NoProfile -Command ^
  "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%TEMP_DIR%\font.zip'"

if not exist "%TEMP_DIR%\font.zip" (
    echo ERROR: Download failed.
    pause
    exit /b 1
)

echo Extracting...
powershell -NoProfile -Command ^
  "Expand-Archive -Force '%TEMP_DIR%\font.zip' '%TEMP_DIR%'"

echo Installing fonts...
for %%F in ("%TEMP_DIR%\*.ttf") do (
    echo Installing %%~nxF
    copy /Y "%%F" "%FONT_DIR%" >nul

    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" ^
        /v "%%~nF (TrueType)" /t REG_SZ /d "%%~nxF" /f >nul
)

echo.
echo ✅ JetBrains Mono Nerd Font installed successfully!
echo.
echo Please restart WezTerm (and any running apps).
pause