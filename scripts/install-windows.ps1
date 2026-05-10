# Dotfiles installer for Windows
# Run: powershell -ExecutionPolicy Bypass -File install-windows.ps1

param()

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$ScriptsDir = "$RepoDir\scripts"
$BinDir = "$env:USERPROFILE\bin"
$ConfigDir = "$env:LOCALAPPDATA"
$NvimConfigDir = "$env:LOCALAPPDATA\nvim"
$ClaudeDir = "$env:USERPROFILE\.claude"
$OpenCodeDir = "$env:LOCALAPPDATA\opencode"
$FontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"

Write-Host "== Windows dotfiles installer ==" -ForegroundColor Cyan

# Create directories
New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
New-Item -ItemType Directory -Force -Path $NvimConfigDir | Out-Null
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
New-Item -ItemType Directory -Force -Path $OpenCodeDir | Out-Null
New-Item -ItemType Directory -Force -Path $FontDir | Out-Null

# ── Helpers ────────────────────────────────────────────────────────────────

function Test-Command($name) {
  return Get-Command $name -ErrorAction SilentlyContinue
}

function Winget-Install($id, $name) {
  if ((winget list --id $id --exact 2>$null).Length -gt 1) {
    Write-Host "Already installed: $name"
    return
  }
  Write-Host "Installing: $name..."
  winget install --id $id --exact --silent --accept-source-agreements --accept-package-agreements
}

# ── System dependencies ────────────────────────────────────────────────────

function Install-Deps {
  Write-Host "`n== Installing system dependencies ==" -ForegroundColor Cyan

  Winget-Install "Neovim.Neovim" "Neovim"
  Winget-Install "Git.Git" "Git"
  Winget-Install "BurntSushi.ripgrep.MSVC" "ripgrep"
  Winget-Install "sharkdp.fd" "fd"
  Winget-Install "JesseDuffield.lazygit" "lazygit"
  Winget-Install "jqlang.jq" "jq"
  Winget-Install "MSYS2.MSYS2" "MSYS2"
  Winget-Install "OpenJS.NodeJS.LTS" "Node.js LTS"
  Winget-Install "Python.Python.3.12" "Python 3.12"
  Winget-Install "GoLang.Go" "Go"

  # Docker Desktop
  if (-not (Test-Command "docker")) {
    Winget-Install "Docker.DockerDesktop" "Docker Desktop"
    Write-Host "Note: Docker Desktop requires a system restart after first install." -ForegroundColor Yellow
  }

  # MSYS2: add ucrt64\bin to PATH for make/gcc (needed by telescope-fzf-native)
  $msys2Bin = "C:\msys64\ucrt64\bin"
  if (Test-Path $msys2Bin) {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notmatch [regex]::Escape($msys2Bin)) {
      [Environment]::SetEnvironmentVariable("Path", "$currentPath;$msys2Bin", "User")
      $env:Path = "$env:Path;$msys2Bin"
      Write-Host "Added MSYS2 to PATH"
    }
  }

  # Ensure pipx
  if (-not (Test-Command "pipx")) {
    python -m pip install --user pipx 2>$null
    python -m pipx ensurepath 2>$null
  }

  Write-Host "System dependencies OK."
}

# ── Nerd Font ──────────────────────────────────────────────────────────────

function Install-Font {
  Write-Host "`n== Installing JetBrainsMono Nerd Font ==" -ForegroundColor Cyan

  # Check if already installed
  $existing = Get-ChildItem $FontDir -Filter "JetBrainsMono*" -ErrorAction SilentlyContinue
  if ($existing) {
    Write-Host "Font already installed."
    return
  }

  Write-Host "Downloading JetBrainsMono Nerd Font..."
  $zipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  $zipFile = "$env:TEMP\JetBrainsMonoNerdFont.zip"
  $extractDir = "$env:TEMP\JetBrainsMonoNerdFont"

  Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile

  Write-Host "Extracting and installing fonts..."
  Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force

  # Install .ttf files
  Get-ChildItem $extractDir -Filter "*.ttf" | ForEach-Object {
    Copy-Item $_.FullName -Destination $FontDir
  }

  Remove-Item -Recurse -Force $extractDir -ErrorAction SilentlyContinue
  Remove-Item $zipFile -ErrorAction SilentlyContinue

  # Register fonts with the system
  Add-Type -AssemblyName System.Drawing
  $shellApp = New-Object -ComObject Shell.Application
  $fonts = $shellApp.Namespace(0x14)
  Get-ChildItem $extractDir -Filter "*.ttf" -ErrorAction SilentlyContinue | ForEach-Object {
    $fonts.CopyHere($_.FullName, 0x14)
  } -ErrorAction SilentlyContinue

  Write-Host "Font installed. Restart your terminal for icons to appear."
}

# ── Python tools ───────────────────────────────────────────────────────────

function Install-PythonTools {
  Write-Host "`n== Installing Python tools ==" -ForegroundColor Cyan

  @("black", "isort") | ForEach-Object {
    $tool = $_
    if (Test-Command $tool) {
      Write-Host "Already installed: $tool"
    } else {
      pipx install $tool
      Write-Host "Installed: $tool"
    }
  }
}

# ── PATH ───────────────────────────────────────────────────────────────────

function Ensure-Path {
  $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if ($currentUserPath -notmatch [regex]::Escape($BinDir)) {
    [Environment]::SetEnvironmentVariable("Path", "$currentUserPath;$BinDir", "User")
    $env:Path = "$env:Path;$BinDir"
    Write-Host "Added ~/bin to user PATH"
  }
}

# ── Scripts ────────────────────────────────────────────────────────────────

function Install-Scripts {
  Write-Host "`n== Linking scripts to ~/bin ==" -ForegroundColor Cyan

  Get-ChildItem $ScriptsDir -File | ForEach-Object {
    $name = $_.Name
    if ($name -match "^(init|install-).*") {
      return
    }
    $target = "$BinDir\$name"
    if (Test-Path $target) {
      Remove-Item $target -Force
    }
    New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName -Force | Out-Null
    Write-Host "Linked: $name"
  }
}

# ── Config symlinks ────────────────────────────────────────────────────────

function Setup-Links {
  Write-Host "`n== Linking configs ==" -ForegroundColor Cyan

  function Link($src, $dest) {
    if (Test-Path $dest) {
      $item = Get-Item $dest -ErrorAction SilentlyContinue
      if ($item -and ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        Write-Host "Already linked: $dest"
        return
      }
      $backup = "$dest.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
      Move-Item $dest $backup
      Write-Host "Backup created for $dest"
    }
    $parent = Split-Path -Parent $dest
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force | Out-Null
    Write-Host "Linked $dest -> $src"
  }

  Link "$RepoDir\skills" "$ClaudeDir\skills"
  Link "$RepoDir\skills" "$OpenCodeDir\skills"

  Link "$RepoDir\claude\CLAUDE.md" "$ClaudeDir\CLAUDE.md"
  Link "$RepoDir\claude\scripts" "$ClaudeDir\scripts"
  Link "$RepoDir\claude\settings.json" "$ClaudeDir\settings.json"
  Link "$RepoDir\claude\settings.local.json" "$ClaudeDir\settings.local.json"

  Link "$RepoDir\nvim" "$NvimConfigDir"
  Link "$RepoDir\opencode" "$OpenCodeDir"
}

# ── Main ───────────────────────────────────────────────────────────────────

function Main {
  Write-Host ""

  # Check for Developer Mode (required for symlinks without admin)
  $devMode = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense
  if (-not $devMode) {
    Write-Host "WARNING: Developer Mode may not be enabled." -ForegroundColor Yellow
    Write-Host "Symlinks require Developer Mode or running as Administrator." -ForegroundColor Yellow
    Write-Host "To enable: Settings > Update & Security > For developers > Developer mode" -ForegroundColor Yellow
    Write-Host ""
  }

  Install-Deps
  Install-Font
  Install-PythonTools
  Ensure-Path
  Install-Scripts
  Setup-Links

  Write-Host ""
  Write-Host "=============================================" -ForegroundColor Cyan
  Write-Host "  Dotfiles installed on Windows." -ForegroundColor Cyan
  Write-Host ""
  Write-Host "  Next steps:"
  Write-Host "  1. Restart your terminal (or run: refreshenv)"
  Write-Host "  2. Open MSYS2 UCRT64 terminal and run: pacman -Syu --noconfirm && pacman -S --noconfirm mingw-w64-ucrt-x86_64-gcc make"
  Write-Host "  3. Run: nvim  (auto-installs plugins & LSPs)"
  Write-Host "=============================================" -ForegroundColor Cyan
}

Main
