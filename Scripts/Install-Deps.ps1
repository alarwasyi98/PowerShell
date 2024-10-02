# Function to check internet connection
function Test-InternetConnection {
    try {
        $pingTest = Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet
        return $pingTest
    }
    catch {
        Write-Error "Failed to test internet connection: $_"
        return $false
    }
}

# Function to check administrator rights
function Test-Administrator {
    try {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($user)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    catch {
        Write-Error "Failed to check administrator rights: $_"
        return $false
    }
}

# Function to install Chocolatey
function Install-Chocolatey {
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
            throw "Chocolatey installation failed."
        }
    }
    catch {
        Write-Error "Failed to install Chocolatey: $_"
        return $false
    }
    return $true
}

# Function to get user choice
function Get-UserChoice {
    param (
        [string]$prompt
    )
    do {
        $choice = Read-Host "$prompt (Y/N)"
        if ($choice -eq 'Y' -or $choice -eq 'N') {
            return $choice
        }
        Write-Host "Invalid input. Please enter Y or N."
    } while ($true)
}

# Function to install package with winget
function Install-WithWinget {
    param (
        [string]$packageName,
        [string]$friendlyName
    )
    if ((Get-UserChoice "Do you want to install $friendlyName?") -eq 'Y') {
        Write-Host "Installing $friendlyName..."
        winget install $packageName --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to install $friendlyName."
            return $false
        }
        return $true
    }
    return $false
}

# Function to install package with Chocolatey
function Install-WithChoco {
    param (
        [string]$packageName,
        [string]$friendlyName
    )
    if ((Get-UserChoice "Do you want to install $friendlyName?") -eq 'Y') {
        Write-Host "Installing $friendlyName..."
        choco install $packageName -y
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to install $friendlyName."
            return $false
        }
        return $true
    }
    return $false
}

# Main script execution
try {
    # Check internet connection
    if (-not (Test-InternetConnection)) {
        throw "No internet connection. Please connect to the internet and try again."
    }

    # Check administrator rights
    if (-not (Test-Administrator)) {
        throw "This script requires administrator rights. Please run as Administrator and try again."
    }

    # Install Chocolatey if not installed
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey is not installed."
        if ((Get-UserChoice "Do you want to install Chocolatey?") -eq 'Y') {
            if (-not (Install-Chocolatey)) {
                throw "Failed to install Chocolatey. Exiting script."
            }
        }
        else {
            throw "Chocolatey is required for this script. Exiting."
        }
    }

    # Update WinGet
    if ((Get-UserChoice "Do you want to update WinGet?") -eq 'Y') {
        Write-Host "Updating WinGet..."
        winget upgrade --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to update WinGet."
        }
    }

    # Install browser
    Install-WithWinget "Google.Chrome" "Google Chrome"

    # Install VSCode and Neovim
    Install-WithWinget "Microsoft.VisualStudioCode" "Visual Studio Code"
    Install-WithChoco "neovim" "Neovim"

    # Install CLI Tools
    $cliTools = @("starship", "zoxide", "fzf", "git")
    foreach ($tool in $cliTools) {
        Install-WithChoco $tool $tool
    }

    # Install PowerShell 7
    if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
        if ((Get-UserChoice "Do you want to install PowerShell 7?") -eq 'Y') {
            Write-Host "Installing PowerShell 7..."
            winget install Microsoft.PowerShell --silent --accept-package-agreements --accept-source-agreements
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to install PowerShell 7."
            }
        }
    }

    # Install PowerShell modules
    if ((Get-UserChoice "Do you want to install PowerShell modules?") -eq 'Y') {
        Write-Host "Installing PowerShell modules..."
        pwsh -Command {
            try {
                Install-Module -Name PSReadLine -Force -SkipPublisherCheck
                Install-Module -Name Terminal-Icons -Force
                Install-Script -Name ps-color-scripts -Force
                Install-Module -Name PSWebSearch -Force
            }
            catch {
                Write-Error "Failed to install PowerShell modules: $_"
                exit 1
            }
        }
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install PowerShell modules."
        }
    }

    Write-Host "Installation process completed successfully!" -ForegroundColor Green
}
catch {
    Write-Error "An error occurred: $_"
    exit 1
}