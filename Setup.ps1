<#
.SYNOPSIS
    PowerShell 7 Environment Setup Script - Automated configuration and module installation

.DESCRIPTION
    This script automates the setup process for a complete PowerShell 7 development environment.
    It performs system checks, installs required modules, configures repositories, and prepares
    the environment for enhanced PowerShell usage with modern tools and utilities.

    The script handles:
    - Administrator privilege verification
    - Internet connectivity testing
    - Git installation verification
    - SSH for Windows feature installation
    - Chocolatey package manager verification
    - PowerShellGet module configuration
    - PSGallery repository trust configuration
    - Essential PowerShell modules installation
    - Comprehensive error handling and reporting

.PARAMETER Verbose
    Enables verbose output for detailed logging of operations

.PARAMETER WhatIf
    Shows what would be performed without actually executing the operations

.EXAMPLE
    .\Setup.ps1
    
    Runs the setup script with default parameters, installing all required modules
    and configuring the PowerShell environment.

.EXAMPLE
    .\Setup.ps1 -Verbose
    
    Runs the setup script with verbose output, providing detailed information
    about each operation performed.

.EXAMPLE
    .\Setup.ps1 -WhatIf
    
    Shows what operations would be performed without actually executing them.
    Useful for testing and verification.

    Get-Help .\Setup.ps1 

    Provides necessary documentation

.INPUTS
    None. This script does not accept pipeline input.

.OUTPUTS
    Console output with colored status messages, progress indicators, and summary report.

.NOTES
    File Name      : Setup.ps1
    Author         : Abdul Hakim (alarwasyi98)
    Prerequisite   : PowerShell 7.0 or higher
    Created        : 2025-06-14
    Last Modified  : 2025-06-14
    Version        : 1.0.0
    
    Requirements:
    - PowerShell 7.0 or higher
    - Internet connection for module downloads
    - Windows 10/11 or Windows Server 2019/2022
    - Administrator privileges (recommended for full functionality)
    
    Modules Installed:
    - Terminal-Icons      : Provides file and folder icons in terminal
    - PSReadLine          : Enhanced command line editing experience
    - Microsoft.WinGet.CommandNotFound : Command suggestions for missing commands
    - ps-color-scripts    : Colorful terminal scripts and themes
    - PSFzf              : Fuzzy finder integration for PowerShell
    - PSWebSearch        : Web search capabilities from PowerShell
    
    Security:
    - All modules are installed from trusted PSGallery repository
    - Script includes comprehensive error handling
    - No external executables are downloaded or executed
    - All operations are logged with colored output

.LINK
    https://github.com/alarwasyi98/PowerShell
    https://docs.microsoft.com/en-us/powershell/
    https://www.powershellgallery.com/

.COMPONENT
    PowerShell Environment Setup

.ROLE
    System Configuration

.FUNCTIONALITY
    Automated PowerShell environment setup and module installation

.USAGE
    1. Download the Setup.ps1 script to your desired location
    2. Open PowerShell 7 as Administrator (recommended)
    3. Navigate to the script directory
    4. Set execution policy if needed: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    5. Run the script: .\Setup.ps1
    6. Follow the on-screen instructions and status messages
    7. Restart PowerShell session after completion
    8. Copy your PowerShell profile configuration to $PROFILE location

    Post-Setup Recommendations:
    - Install additional tools via winget (Oh My Posh, fzf, zoxide, bat, neovim, yazi)
    - Configure your PowerShell profile with custom functions and aliases
    - Set up Starship prompt configuration
    - Configure SSH keys and Git credentials
#>

#Requires -Version 7.0

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(HelpMessage = "Show verbose output during execution")]
    [switch]$Verbose,
    
    [Parameter(HelpMessage = "Show what would be done without executing")]
    [switch]$WhatIf
)

#        .__
# _____  |  |     POWERSHELL 7 SETUP SCRIPT
# \__  \ |  |     Abdul Hakim (alarwasyi98)
#  / __ \|  |__   https://github.com/alarwasyi98/PowerShell
# (____  /____/   Version 1.0.0
#      \/

# Script metadata
$ScriptInfo = @{
    Name = "PowerShell 7 Environment Setup Script"
    Version = "1.0.0"
    Author = "Abdul Hakim (alarwasyi98)"
    Created = "2025-06-14"
    Repository = "https://github.com/alarwasyi98/PowerShell"
    Description = "Automated PowerShell 7 environment configuration and module installation"
}

# Color definitions for output
$Red = [System.ConsoleColor]::Red
$Green = [System.ConsoleColor]::Green
$Yellow = [System.ConsoleColor]::Yellow
$Cyan = [System.ConsoleColor]::Cyan
$White = [System.ConsoleColor]::White
$Magenta = [System.ConsoleColor]::Magenta

function Write-ColorOutput {
    param(
        [string]$Message,
        [System.ConsoleColor]$Color = $White
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Step {
    param([string]$Message)
    Write-ColorOutput "`n[STEP] $Message" $Cyan
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "[SUCCESS] $Message" $Green
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "[WARNING] $Message" $Yellow
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "[ERROR] $Message" $Red
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-InternetConnection {
    try {
        $testConnection = Test-NetConnection -ComputerName "8.8.8.8" -Port 53 -InformationLevel Quiet -WarningAction SilentlyContinue
        return $testConnection
    }
    catch {
        return $false
    }
}

function Install-ModuleWithErrorHandling {
    param(
        [string]$ModuleName,
        [switch]$AllowPrerelease
    )
    
    try {
        Write-Step "Installing $ModuleName module..."
        
        if (Get-Module -ListAvailable -Name $ModuleName) {
            Write-Warning "$ModuleName is already installed. Updating..."
            if ($AllowPrerelease) {
                Update-Module -Name $ModuleName -AllowPrerelease -Force -ErrorAction Stop
            } else {
                Update-Module -Name $ModuleName -Force -ErrorAction Stop
            }
        } else {
            if ($AllowPrerelease) {
                Install-Module -Name $ModuleName -AllowPrerelease -Scope CurrentUser -Force -ErrorAction Stop
            } else {
                Install-Module -Name $ModuleName -Scope CurrentUser -Force -ErrorAction Stop
            }
        }
        
        Write-Success "$ModuleName installed/updated successfully"
        return $true
    }
    catch {
        Write-Error "Failed to install $ModuleName : $($_.Exception.Message)"
        return $false
    }
}

# Main Setup Function
function Start-PowerShellSetup {
    Write-ColorOutput @"
    
    ╔══════════════════════════════════════════════════════════════╗
    ║                    PowerShell 7 Setup Script                 ║
    ║                   Abdul Hakim (alarwasyi98)                  ║
    ║           https://github.com/alarwasyi98/PowerShell          ║
    ╚══════════════════════════════════════════════════════════════╝
    
"@ $Cyan

    # Check Administrator Privileges
    Write-Step "Checking administrator privileges..."
    if (-not (Test-Administrator)) {
        Write-Warning "Some features require administrator privileges."
        Write-ColorOutput "Consider running as administrator for full functionality." $Yellow
    } else {
        Write-Success "Running with administrator privileges"
    }

    # Check Internet Connection
    Write-Step "Checking internet connection..."
    if (-not (Test-InternetConnection)) {
        Write-Error "No internet connection detected. Cannot proceed with setup."
        return
    }
    Write-Success "Internet connection verified"

    # Check Git Installation
    Write-Step "Checking Git installation..."
    try {
        $gitVersion = git --version 2>$null
        if ($gitVersion) {
            Write-Success "Git is installed: $gitVersion"
        } else {
            throw "Git not found"
        }
    }
    catch {
        Write-Warning "Git is not installed or not in PATH"
        Write-ColorOutput "Please install Git from: https://git-scm.com/download/win" $Yellow
        Write-ColorOutput "Or use: winget install Git.Git" $Yellow
    }

    # Check SSH for Windows Feature
    Write-Step "Checking SSH for Windows feature..."
    try {
        $sshClient = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*'
        $sshServer = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
        
        if ($sshClient.State -eq "Installed") {
            Write-Success "SSH Client is installed"
        } else {
            Write-Warning "SSH Client is not installed"
            if (Test-Administrator) {
                try {
                    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
                    Write-Success "SSH Client installed successfully"
                }
                catch {
                    Write-Error "Failed to install SSH Client: $($_.Exception.Message)"
                }
            } else {
                Write-ColorOutput "Run as administrator to install SSH Client automatically" $Yellow
            }
        }
    }
    catch {
        Write-Error "Failed to check SSH installation: $($_.Exception.Message)"
    }

    # Check Chocolatey Installation
    Write-Step "Checking Chocolatey installation..."
    try {
        $chocoVersion = choco --version 2>$null
        if ($chocoVersion) {
            Write-Success "Chocolatey is installed: v$chocoVersion"
        } else {
            throw "Chocolatey not found"
        }
    }
    catch {
        Write-Warning "Chocolatey is not installed"
        Write-ColorOutput "Install from: https://chocolatey.org/install" $Yellow
        Write-ColorOutput "Or run: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" $Yellow
    }

    # Configure PowerShellGet and PSGallery
    Write-Step "Configuring PowerShellGet and PSGallery repository..."
    try {
        # Update PowerShellGet
        if (Get-Module -ListAvailable -Name PowerShellGet) {
            Write-Success "PowerShellGet is available"
            Update-Module PowerShellGet -Force -ErrorAction SilentlyContinue
        } else {
            Install-Module PowerShellGet -Force -AllowClobber -ErrorAction Stop
        }

        # Set PSGallery as trusted
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction Stop
        Write-Success "PSGallery repository set to trusted"
    }
    catch {
        Write-Error "Failed to configure PowerShellGet/PSGallery: $($_.Exception.Message)"
    }

    # Install Required Modules
    $modules = @(
        @{ Name = "Terminal-Icons"; AllowPrerelease = $false },
        @{ Name = "PSReadLine"; AllowPrerelease = $true },
        @{ Name = "Microsoft.WinGet.CommandNotFound"; AllowPrerelease = $false },
        @{ Name = "ps-color-scripts"; AllowPrerelease = $false },
        @{ Name = "PSFzf"; AllowPrerelease = $false },
        @{ Name = "PSWebSearch"; AllowPrerelease = $false }
    )

    $successCount = 0
    $totalModules = $modules.Count

    foreach ($module in $modules) {
        if ($module.AllowPrerelease) {
            $result = Install-ModuleWithErrorHandling -ModuleName $module.Name -AllowPrerelease
        } else {
            $result = Install-ModuleWithErrorHandling -ModuleName $module.Name
        }
        
        if ($result) {
            $successCount++
        }
    }

    # Summary
    Write-ColorOutput "`n╔══════════════════════════════════════════════════════════════╗" $Cyan
    Write-ColorOutput "║                        SETUP SUMMARY                           ║" $Cyan
    Write-ColorOutput "╚════════════════════════════════════════════════════════════════╝" $Cyan
    
    Write-ColorOutput "`nModules Installation: $successCount/$totalModules completed" $White
    
    if ($successCount -eq $totalModules) {
        Write-Success "`nAll modules installed successfully!"
    } else {
        Write-Warning "`nSome modules failed to install. Check the errors above."
    }

    Write-ColorOutput "`nNext Steps:" $Cyan
    Write-ColorOutput "1. Restart your PowerShell session" $White
    Write-ColorOutput "2. Copy your PowerShell profile to: $PROFILE" $White
    Write-ColorOutput "3. Install additional tools:" $White
    Write-ColorOutput "   - winget install junegunn.fzf" $White
    Write-ColorOutput "   - winget install ajeetdsouza.zoxide" $White
    Write-ColorOutput "   - winget install sharkdp.bat" $White
    Write-ColorOutput "   - winget install Neovim.Neovim" $White
    Write-ColorOutput "   - winget install sxyazi.yazi" $White
    
    Write-ColorOutput "`nSetup completed! Enjoy your enhanced PowerShell experience! 🚀" $Green
}

# Execute the setup
try {
    Start-PowerShellSetup
}
catch {
    Write-Error "Setup failed with error: $($_.Exception.Message)"
    Write-ColorOutput "Please check the error details above and try again." $Yellow
}

# Pause to allow user to read the output
Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
