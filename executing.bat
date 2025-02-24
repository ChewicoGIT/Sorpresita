@echo off
setlocal

:: Get the script's directory (removes trailing backslash if present)
set "scriptDir=%~dp0"
set "scriptDir=%scriptDir:~0,-1%"

:: Define installer and target executable paths
set "dotnetInstaller=%scriptDir%\dotnet-installer.exe"
set "targetApp=%scriptDir%\your-app.exe"

:: Install .NET 8 silently
"%dotnetInstaller%" /quiet /norestart

:: Check if installation was successful
if %errorlevel% equ 0 (
    :: Define the startup shortcut path
    set "startupShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\your-app.lnk"

    :: Define PowerShell script path
    set "psScript=%TEMP%\create_shortcut.ps1"

    :: Create a PowerShell script to make the shortcut
    echo $ws = New-Object -ComObject WScript.Shell > "%psScript%"
    echo $s = $ws.CreateShortcut("%startupShortcut%") >> "%psScript%"
    echo $s.TargetPath = "%targetApp%" >> "%psScript%"
    echo $s.Save() >> "%psScript%"

    :: Run the PowerShell script with correct escaping
    powershell -ExecutionPolicy Bypass -NoProfile -File "%psScript%"

    :: Delete the temporary PowerShell script
    del "%psScript%"
) else (
    :: Log an error (optional)
    echo Failed to install .NET 8. Exit code: %errorlevel% > "%scriptDir%\install-error.log"
)

exit /b
