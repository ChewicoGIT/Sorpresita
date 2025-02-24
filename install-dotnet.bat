@echo off
setlocal

:: Define the URL for the .NET 8 SDK installer (modify if needed)
set "dotnetURL=https://download.visualstudio.microsoft.com/download/pr/653d3db1-4143-46e3-8053-4e7d926dc57a/6829b773c79d2367d441f5b8ec38b365/dotnet-sdk-8.0.100-win-x64.exe"

:: Get script directory
set "scriptDir=%~dp0"

:: Define installer and application paths
set "dotnetInstaller=%scriptDir%dotnet-installer.exe"
set "targetApp=%scriptDir%Sorpresita.exe"

:: Download the .NET SDK installer if not already downloaded
if not exist "%dotnetInstaller%" (
    echo Downloading .NET 8 SDK installer...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%dotnetURL%', '%dotnetInstaller%')"
)

:: Install .NET 8 SDK silently (replace '/S' with the actual silent install flag for your installer)
echo Installing .NET 8 SDK...
"%dotnetInstaller%" /quiet /norestart

:: Check if installation was successful
if %errorlevel% equ 0 (
    echo Installation successful. Adding Sorpresita.exe to startup...
    
    :: Define startup shortcut path
    set "startupShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Sorpresita.lnk"
    
    :: Create a shortcut using PowerShell
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%startupShortcut%'); $s.TargetPath = '%targetApp%'; $s.Save()"

    echo Done! Sorpresita.exe will run on startup.
) else (
    echo Failed to install .NET 8. Exit code: %errorlevel% > "%scriptDir%install-error.log"
)

exit /b
