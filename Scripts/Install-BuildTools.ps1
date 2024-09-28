function Install-BuildTools {
    $command = 'winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--passive --add Microsoft.VisualStudio.Workload.VCTools;includeRecommended"'
    Write-Host "Installing C Compiler (Visual Studio Build Tools 2022 with C++ workload)..." -ForegroundColor Cyan
    try {
        Invoke-Expression $command
        Write-Host "Installation completed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred during installation: $_" -ForegroundColor Red
    }
}
