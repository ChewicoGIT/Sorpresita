@echo off
setlocal

:: Get the script's directory (current folder)
set "scriptDir=%~dp0"

:: Define URLs for .NET SDK 8 installer and target install path
set "dotnetUrl=https://dotnet.microsoft.com/es-es/download/dotnet/thank-you/runtime-desktop-8.0.13-windows-x64-installer"
set "installerPath=%scriptDir%dotnet-sdk-8-installer.exe"

:: Download .NET SDK 8 installer to the same folder as the script
echo Downloading .NET SDK 8...
powershell -Command "Invoke-WebRequest -Uri %dotnetUrl% -OutFile %installerPath%"

:: Install .NET SDK 8 silently in the same folder
echo Installing .NET SDK 8...
start /wait %installerPath% /quiet /norestart /path="%scriptDir%"

:: Check if installation was successful
if %errorlevel% equ 0 (
    echo .NET SDK 8 installed successfully in %scriptDir%.
) else (
    echo Failed to install .NET SDK 8. Exit code: %errorlevel%
    exit /b
)

:: Define the target application and startup folder
set "appPath=%~dp0sorprestia.exe"
set "startupShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\sorprestia.lnk"

:: Create the startup shortcut
echo Creating shortcut for sorprestia.exe in the Startup folder...
set "vbsScript=%TEMP%\create_shortcut.vbs"
echo Set WshShell = CreateObject("WScript.Shell") > "%vbsScript%"
echo Set shortcut = WshShell.CreateShortcut("%startupShortcut%") >> "%vbsScript%"
echo shortcut.TargetPath = "%appPath%" >> "%vbsScript%"
echo shortcut.Save >> "%vbsScript%"

:: Run the VBS script to create the shortcut
cscript //nologo "%vbsScript%"

:: Clean up the VBS script and installer
del "%vbsScript%"
del "%installerPath%"

echo Installation complete. sorprestia.exe will run on startup.

exit /b
