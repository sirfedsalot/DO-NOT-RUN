@echo off
setlocal enabledelayedexpansion

:: Check for admin privileges (assuming this is needed)
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrative privileges. Please run as administrator.
    pause
    exit /b 1
)

:: Define file paths
set "batchScript=%TEMP%\hidden_runner.bat"
set "vbsScript=%TEMP%\hidden_runner.vbs"

:: Display the TEMP directory for verification
echo TEMP directory: %TEMP%

:: Create the temporary batch script
(
    echo @echo off
    echo echo Running hidden batch script...
    echo rem Add your commands here
) > "%batchScript%"

:: Check if the batch script was created
if not exist "%batchScript%" (
    echo Error: Could not create batch script at %batchScript%
    pause
    exit /b 1
) else (
    echo Batch script created successfully at %batchScript%
)

:: Create the VBScript to run the batch script silently
(
    echo Set objShell = CreateObject("WScript.Shell")
    echo objShell.Run "cmd.exe /c %batchScript%", 0, False
) > "%vbsScript%"

:: Check if the VBScript was created
if not exist "%vbsScript%" (
    echo Error: Could not create VBScript at %vbsScript%
    pause
    exit /b 1
) else (
    echo VBScript created successfully at %vbsScript%
)

:: Run the VBScript
cscript //nologo "%vbsScript%"

:: Optional cleanup
del "%batchScript%" >nul 2>&1
del "%vbsScript%" >nul 2>&1

echo Script completed.
pause
exit /b 0
