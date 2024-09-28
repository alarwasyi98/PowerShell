function whereis {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command
    )
    $results = @()

    # Search in PATH
    $pathLocations = $env:PATH -split ';' | ForEach-Object {
        Join-Path $_ "$Command*"
    }
    $executableLocations = Get-ChildItem -Path $pathLocations -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -match "^$Command(\.exe|\.cmd|\.bat)?$" }

    # Search for PowerShell modules
    $moduleLocations = Get-Module -Name $Command -ListAvailable

    # Search for help files
    $helpLocations = Get-Help $Command -ErrorAction SilentlyContinue |
    Where-Object { $null -ne $_.Path } |
    Select-Object -ExpandProperty Path

    if ($executableLocations) {
        $results += "Executables:"
        $results += $executableLocations.FullName | ForEach-Object { "  $_" }
    }

    if ($moduleLocations) {
        $results += "PowerShell Modules:"
        $results += $moduleLocations.Path | ForEach-Object { "  $_" }
    }

    if ($helpLocations) {
        $results += "Help Files:"
        $results += $helpLocations | ForEach-Object { "  $_" }
    }

    if ($results.Count -eq 0) {
        Write-Host "No locations found for '$Command'" -ForegroundColor Yellow
    }
    else {
        $results | ForEach-Object { Write-Host $_ }
    }
}
