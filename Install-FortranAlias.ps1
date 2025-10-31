# ===================================================================
# Install-FortranAlias.ps1
# Run this script ONCE to create a permanent 'frun' alias.
# It automatically finds 'Invoke-FortranRun.ps1' if it's in the same directory.
# ===================================================================

# --- SCRIPT LOGIC ---

# $PSScriptRoot is an automatic variable that contains the directory of this script.
# This makes the script location-independent!
$scriptDirectory = $PSScriptRoot
$runnerScriptName = "Invoke-FortranRun.ps1"
$runnerScriptPath = Join-Path $scriptDirectory $runnerScriptName

# Check if the main runner script actually exists in the same folder.
if (-not (Test-Path $runnerScriptPath)) {
    Write-Error "FATAL: Could not find '$runnerScriptName' in the same directory as this installer."
    Write-Error "Please make sure both scripts are saved in the same folder."
    return
}

$aliasName = "frun"
$profilePath = $PROFILE

# Ensure the profile file exists
if (-not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
}

# Define the function and alias block to be added to the profile.
# It uses the full, discovered path to the runner script.
$profileContent = @"

# Alias and function to compile/run the active Fortran file
function Invoke-FortranCompileAndRun {
    & '$runnerScriptPath'
}
Set-Alias -Name '$aliasName' -Value 'Invoke-FortranCompileAndRun' -Option AllScope -Force
"@

Write-Host "--- Setting up 'frun' alias ---" -ForegroundColor Cyan
Add-Content -Path $profilePath -Value $profileContent
Write-Host "Success! Alias '$aliasName' has been added to your PowerShell profile." -ForegroundColor Green
Write-Host "It now correctly points to: $runnerScriptPath" -ForegroundColor Yellow
Write-Host "Please RESTART your PowerShell terminal to activate the 'frun' command." -ForegroundColor Green