function Remove-IfExists {
    param (
        [string]$Path
    )
    if (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Recurse -Force
        Write-Host "Removed: $Path" -ForegroundColor Green
    } else {
        Write-Host "Directory not found: $Path" -ForegroundColor Yellow
    }
}

Write-Host "Starting Neovim configuration removal..." -ForegroundColor Cyan

# Remove Neovim configurations
Remove-IfExists -Path "$env:LOCALAPPDATA\nvim"
Remove-IfExists -Path "$env:LOCALAPPDATA\nvim-data"

Write-Host "Neovim configuration removal completed!" -ForegroundColor Cyan
