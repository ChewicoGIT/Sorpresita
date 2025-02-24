# Get the script's directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define installer and target executable paths
$dotnetInstaller = "$scriptDir\dotnet-installer.exe"
$targetApp = "$scriptDir\your-app.exe"

# Install .NET 8 silently
Write-Host "Installing .NET 8..."
Start-Process -FilePath $dotnetInstaller -ArgumentList "/quiet /norestart" -NoNewWindow -Wait

# Check if installation was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host ".NET 8 installed successfully."

    # Define startup shortcut path
    $startupShortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\your-app.lnk"

    # Create a WScript shell object to make the shortcut
    $ws = New-Object -ComObject WScript.Shell
    $shortcut = $ws.CreateShortcut($startupShortcut)
    $shortcut.TargetPath = $targetApp
    $shortcut.Save()

    Write-Host "Shortcut created in Startup folder: $startupShortcut"
} else {
    # Log an error (optional)
    Write-Host "Failed to install .NET 8. Exit code: $LASTEXITCODE"
    Add-Content -Path "$scriptDir\install-error.log" -Value "Failed to install .NET 8. Exit code: $LASTEXITCODE"
}
