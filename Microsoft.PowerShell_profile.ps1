#        .__
# _____  |  |     POWERSHELL 7 SETUP
# \__  \ |  |     Abdul Hakim (alarwasyi98)
#  / __ \|  |__   https://github.com/alarwasyi98
# (____  /____/
#      \/

### ENVIRONMENT VARIABLES ###

# Exporting chocolatey profile to enable tab-completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

### ALIASES ###
Set-Alias tt tree
Set-Alias ll ls
Set-Alias -Name la -Value "Get-ChildItem -Path . -Force | Format-Table -AutoSize"
Set-Alias -Name ln -Value "Get-ChildItem -Name | Format-Table -Autosize"

Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias cat bat
Set-Alias h -Value Get-History

Set-Alias -Name touch -Value "New-Item -Type File"
Set-Alias -Name docs -Value "Set-Location -Path $HOME\Documents"
Set-Alias -Name pict -Value "Set-Location -Path $HOME\Pictures"
Set-Alias -Name ep -Value "nvim $PROFILE"
Set-Alias -Name sedit -Value "vim $HOME\.config\starship.toml"

# Set UNIX-like aliases for the admin command, See function below
# so sudo <command> will run the command with elevated rights.
Set-Alias -Name su -Value admin

### UNUSED ALIASES ###
#Set-Alias -Name wa -Value Start-WhatsApp

### FUNCTIONS ###

# Git
function gs { git status }
function ga { git add . }
function gcm { param($m) git commit -m "$m" }
function gp { git push }
function g { z Github }
function gcl { git clone "$args" }
function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}

# fzf
function bfzf {
    fzf --preview="bat --decorations=always --color=always {}"
}

function fzfvim {
  nvim (fzf --preview="bat --decorations=always --color=always {}")
}

### SPECIAL FUNCTIONS ###

# Run as Administrator
function admin {
    if ($args.Count -gt 0) {
        $argList = "& '$args'"
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    } else {
        Start-Process wt -Verb runAs
    }
}

# Print command location
function which {
  param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$command  
  )

  $result = Get-Command $command -ErrorAction SilentlyContinue

  if ($result) {
    $result.Source
    } else {
        Write-Host "${command} not found"
    }
}

# Reload PowerShell Profiles for All Users
function Reload-Profile {
    # Memuat ulang profil PowerShell
    . $PROFILE
    Write-Output "Profile Reloaded"
}

# Locate file quickly
function ff($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "$($_.FullName)"
    }
}

# Extract ZIP File
function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

# Start WhatsApp Desktop
# NOTE: Disabled due to performance issues
## Start-Process Appx
#function Start-WhatsApp {
#    # Get package's name
#    $whatsappPackage = Get-AppxPackage -Name "*WhatsAppDesktop*"
#    # Check if package found
#    if ($whatsappPackage) {
#        # Run WhatsApp
#        $packageFullName = $whatsappPackage.PackageFamilyName
#        Start-Process "shell:appsFolder\$packageFullName!App" -ErrorAction SilentlyContinue
#        Write-Output "WhatsApp Started"
#    } else {
#        Write-Output "WhatsApp not found!"
#    }
#}

### MODULES IMPORTER ###

# Terminal-Icons
Import-Module Terminal-Icons

# PSReadline; fish-like capability
Import-Module PSReadline
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineOption -PredictionViewStyle InlineView 
Set-PsReadlineOption -PredictionSource History
# Set-PSReadlineOption -PredictionViewStyle InlineView

# Command Not Found (PowerToys)
Import-Module -Name Microsoft.WinGet.CommandNotFound
# f45873b3-b655-43a6-b217-97c00aa0db58

### INVOCATIONS ###

# starship
Invoke-Expression (&starship init powershell)

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
