@echo off
setlocal ENABLEEXTENSIONS

echo.
echo ⚠️  WARNING: This will COMPLETELY RESET your WSL2 Ubuntu installation.
echo     All Linux files will be DELETED.
echo.

set /p CONFIRM=Type YES to continue: 
if /I not "%CONFIRM%"=="YES" (
    echo Aborted.
    exit /b 0
)

echo.
echo Shutting down WSL...
wsl --shutdown

echo Removing Ubuntu...
wsl --unregister Ubuntu

echo Reinstalling Ubuntu...
wsl --install -d Ubuntu

echo.
echo ✅ Ubuntu reset and reinstall started.
echo.
echo IMPORTANT:
echo   - A new window will open
echo   - Complete initial user setup
echo   - Then restart WezTerm
echo.
pause