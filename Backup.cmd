@echo off
setlocal enabledelayedexpansion

:: Get the directory where the script is running
set "scriptDir=%~dp0"

:: Create log directory if it does not exist
if not exist "%scriptDir%log\" mkdir "%scriptDir%log"

:: Get the current date and time in yyyymmddhhmm format
for /F "tokens=2 delims==" %%I in ('wmic OS Get localdatetime /value') do set "datetime=%%I"
set "datestamp=%datetime:~0,12%"

:: Define the log file path with date and time suffix
set "logFile=%scriptDir%log\backup-%datestamp%.log"

:: Read each line from backup.txt
for /F "usebackq tokens=*" %%A in ("%scriptDir%backup.txt") do (
    :: Extract the folder name from the path
    for %%B in ("%%A") do (
        set "folderName=%%~nxB"

        :: Check if the target directory already exists, if not, create it
        if not exist "!scriptDir!!folderName!\" (
            mkdir "!scriptDir!!folderName!"
        )
        
        :: Execute Robocopy and log the operation, excluding "desktop.ini", with no retries on locked files
        robocopy "%%~A" "!scriptDir!!folderName!" /E /XF desktop.ini /R:0 /W:0 /LOG+:!logFile! /NP /TEE
    )
)

echo All tasks completed with the utmost efficiency and no pesky waiting. Dive into the log folder for a thrilling read.
endlocal
