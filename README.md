# PowerShell Configuration

![Static Badge](https://img.shields.io/badge/PowerShell-blue?style=for-the-badge&logo=opentofu&logoColor=white)

This repository contains the configuration files and scripts for my PowerShell setup. It includes my PowerShell profile, modules, and various utility scripts.

## Repository Structure

The repository is organized as follows:

| Section                   | Description                                                                                |
| ------------------------- | ------------------------------------------------------------------------------------------ |
| **Applications**          | These are the external applications that are a dependency for my PowerShell setup.         |
| **Modules**               | These are the PowerShell modules that I have installed and configured.                     |
| **Scripts**               | These are the custom PowerShell scripts that I have created for various purposes.          |
| **Additional Repository** | These are the additional Git repositories that I have integrated into my PowerShell setup. |

### Applications

| Application  | Description                        |
| ------------ | ---------------------------------- |
| `chocolatey` | Package manager for Windows        |
| `neovim`     | Vim-based text editor              |
| `starship`   | Cross-shell prompt                 |
| `git`        | Distributed version control system |
| `fzf`        | Fuzzy finder                       |

### Modules

| Module              | Description                                     |
| ------------------- | ----------------------------------------------- |
| `Terminal-Icons`    | Provides file icons for the terminal            |
| `PSReadline`        | Enhances the PowerShell command-line experience |
| `Command-Not-Found` | Provides suggestions for missing commands       |

### Scripts

| Script               | Description                                        |
| -------------------- | -------------------------------------------------- |
| `Install-Deps`       | Installing Dependencies that support this profile  |
| `Configuring-Git`    | Sets up Git configuration and aliases              |
| `Get-Linux`          | Retrieves information about the Linux environment  |
| `Windows-Utility`    | Provides various Windows-related utility functions |
| `Remove-Neovim`      | Removes the Neovim installation                    |
| `Install-BuildTools` | Installs the necessary build tools                 |

### Additional Repository

| Repository      | Description                               |
| --------------- | ----------------------------------------- |
| `PSGallery`     | The official PowerShell script repository |
| `PowerShellGet` | The official PowerShell module repository |

## Usage

To use this PowerShell configuration, simply clone this repo to your local machine.

> [!note]
> Open a PowerShell terminal (version 5.1 or later) and from the PS C:\Users\username\Documents> prompt, then run the following command:

```sh
git clone https://github.com/alarwasyi98/PowerShell.git
```

1. Clone the repository to your local machine.
2. Run the necessary setup scripts to install the required applications and configure the environment.
3. Customize the PowerShell profile and scripts as needed.

Feel free to explore the repository and use the provided scripts and configurations to enhance your PowerShell experience.

## Contributing

If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.
