# ===================================================================
# Invoke-FortranRun.ps1
# Compiles and runs the active Fortran file from VS Code.
# This file is called by the 'frun' alias.
# ===================================================================

function Get-VSCodeActiveFortranFile {
    try {
        $vsCodeProcess = Get-Process -Name 'Code' -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle }
        if ($vsCodeProcess) {
            $windowTitle = $vsCodeProcess[0].MainWindowTitle
            $filePath = ($windowTitle.Split(' - ')[0]).Trim()

            if ($filePath -and (Test-Path $filePath) -and $filePath -match '\.(f90|f95|f|for)$') {
                return (Get-Item $filePath).FullName
            }
        }
    } catch { }
    return $null
}

# --- Main Script Logic ---
$fortranFileFullPath = Get-VSCodeActiveFortranFile
if (-not $fortranFileFullPath) {
    Write-Error "ERROR: No active Fortran file (.f90, .f95, .f, .for) found in VS Code."
    return
}

$fileInfo = Get-Item $fortranFileFullPath
$sourceDirectory = $fileInfo.DirectoryName
$sourceFileName = $fileInfo.Name
$baseName = $fileInfo.BaseName
$executableName = "$($baseName).exe"

Push-Location -Path $sourceDirectory
Write-Host "Changed working directory to `"$sourceDirectory`"" -ForegroundColor Cyan

Write-Host "Attempting to compile `"$sourceFileName`"..." -ForegroundColor Yellow
gfortran -o $executableName $sourceFileName

if ($LASTEXITCODE -eq 0) {
    Write-Host "Compilation successful. Running `"$executableName`"..." -ForegroundColor Green
    Write-Host "-------------------- PROGRAM OUTPUT --------------------"
    & ".\$executableName"
    Write-Host "------------------------------------------------------"
} else {
    Write-Error "Compilation failed. Check gfortran output for errors."
}

Pop-Location