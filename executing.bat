@echo off
setlocal

:: Get the script's directory
set "scriptDir=%~dp0"

:: Define installer and target executable paths
set "dotnetInstaller=%scriptDir%dotnet-installer.exe"
set "targetApp=%scriptDir%your-app.exe"

:: Install .NET 8 silently
"%dotnetInstaller%" /quiet /norestart

:: Check if installation was successful
if %errorlevel% equ 0 (
    :: Add the app to Windows Startup
    set "startupShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\your-app.lnk"

    :: Create a PowerShell script to make the shortcut
    set "psScript=%scriptDir%create_shortcut.ps1"
    
    echo $ws = New-Object -ComObject WScript.Shell > "%psScript%"
    echo $s = $ws.CreateShortcut("%startupShortcut%") >> "%psScript%"
    echo $s.TargetPath = "%targetApp%" >> "%psScript%"
    echo $s.Save() >> "%psScript%"

    :: Run the PowerShell script
    powershell -ExecutionPolicy Bypass -File "%psScript%"

    :: Delete the temporary PowerShell script
    del "%psScript%"
) else (
    :: Log an error (optional)
    echo Failed to install .NET 8. Exit code: %errorlevel% > "%scriptDir%install-error.log"
)

exit /b
