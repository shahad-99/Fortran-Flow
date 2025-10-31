# ===================================================================
# Self-Installing Alias Setup
# This block runs only if the 'frun' alias doesn't already exist.
# ===================================================================
$aliasName = "frun"

if (-not (Get-Command $aliasName -ErrorAction SilentlyContinue)) {
    # The alias does not exist, so let's create it permanently.

    # First, check if the script is being run from a saved file.
    if ($MyInvocation.MyCommand.Path) {
        Write-Host "--- First-time setup ---" -ForegroundColor Cyan
        Write-Host "Creating permanent alias '$aliasName' for this script." -ForegroundColor Cyan

        # Get the full path to this script file.
        $scriptPath = $MyInvocation.MyCommand.Path

        # Define the content to add to the PowerShell profile.
        # This creates a function and an alias for it, which is robust.
        $profileContent = @"

# Alias and function to compile/run the active Fortran file in VS Code
function Invoke-FortranCompileAndRun {
    & '$scriptPath' # Execute the script
}
Set-Alias -Name '$aliasName' -Value 'Invoke-FortranCompileAndRun'
"@

        # Ensure the profile file exists before trying to add content to it.
        if (-not (Test-Path $PROFILE)) {
            New-Item -Path $PROFILE -ItemType File -Force | Out-Null
        }

        # Add the function and alias definition to the end of the profile file.
        Add-Content -Path $PROFILE -Value $profileContent

        Write-Host "Alias '$aliasName' has been added to your profile." -ForegroundColor Green
        Write-Host "Please restart your PowerShell terminal or run '. `"$PROFILE`"' to use the new alias." -ForegroundColor Yellow
        Write-Host "--------------------------" -ForegroundColor Cyan
    }
    else {
        Write-Warning "To create a permanent alias, please save this script to a file and run it from there."
    }
}


# ===================================================================
# Helper Functions (Required for the script to work)
# ===================================================================

function Get-VSCodeActiveFile {
    [CmdletBinding()]
    param()
    try {
        $vsCodeProcess = Get-Process | Where-Object { $_.ProcessName -eq 'Code' -and $_.MainWindowTitle }
        if ($vsCodeProcess) {
            $windowTitle = $vsCodeProcess[0].MainWindowTitle
            $titleParts = $windowTitle.Split(' - ')
            if ($titleParts.Count -ge 3) {
                [PSCustomObject]@{
                    FileName  = $titleParts[0].Trim()
                    Workspace = $titleParts[1].Trim()
                }
            } else {
                # Handles cases where there's no workspace open, just a file
                $fileName = $windowTitle.Split(' - ')[0].Trim()
                if ($fileName) { [PSCustomObject]@{ FileName = $fileName; Workspace = "Unknown" } }
            }
        }
    } catch {
        # Fails silently if VS Code isn't running
    }
}

function Get-FileInfo {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$FilePath)
    process {
        try {
            $file = Get-Item -Path $FilePath -ErrorAction Stop
            [PSCustomObject]@{
                FullName  = $file.FullName
                Name      = $file.Name
                BaseName  = $file.BaseName
                Extension = $file.Extension
            }
        } catch {
            # This function will now return nothing if the file isn't found,
            # allowing the main script to handle the error message.
        }
    }
}


# ===================================================================
# Main Script Logic (Compile and Run Fortran)
# ===================================================================

$loc = Get-VSCodeActiveFile
if (-not $loc) {
    Write-Warning "Could not determine the active file in VS Code. Aborting script."
    return
}

$info = Get-FileInfo $loc.FileName
if (-not $info) {
    Write-Warning "File '$($loc.FileName)' not found in the current directory. Aborting script."
    return
}

$basename = $info.BaseName
$name = $info.Name
$executableName = "$($basename).exe"

Write-Host "Attempting to compile '$name'..." -ForegroundColor Yellow
gfortran $name -o $basename

if ($LASTEXITCODE -eq 0) {
    Write-Host "Compilation successful. Running '$executableName'..." -ForegroundColor Green
    & ".\$executableName"
}
else {
    Write-Error "Compilation failed. Please check the output from gfortran for errors."
}