# Title: PowerShell script to install VSCode, nodejs, etc
# Author: David Burg
# Project: Vibe coding
# Date: 12/10/2026


# ---------------------- Get Admin privelegs -------------------------------

# Check if current session has Administrator privileges
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$isAdmin =$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Requesting administrative privileges..." -ForegroundColor Yellow

    # Relaunch script with elevated permissions ('RunAs')
    $scriptPath =$MyInvocation.MyCommand.Path
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

    # Exit current non-elevated process
    exit
}

# --- YOUR ELEVATED CODE GOES HERE ---
Write-Host "Running with administrative privileges!" -ForegroundColor Green



# ---------------------- Get everything ready -------------------------------

# Find latest vscode
    $VSCODE_VERSION = (Invoke-RestMethod -Uri "https://update.code.visualstudio.com/api/update/win32-x64/stable/latest").productVersion
# Find latest nodejs
    $NODEJS_VERSION = [string]((Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json")[0].version).TrimStart('v')
# Find latest git
    $GIT_VERSION1 = (Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest").tag_name
    $GIT_VERSION2 = if (((Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest").assets | Where-Object name -match 'PortableGit-.*-64-bit\.7z\.exe').name -match 'PortableGit-(.*?)-64-bit') { $Matches[1] }
# Find latest omnituote
    $OMNIROUTE_VERSION = ((Invoke-RestMethod "https://api.github.com/repos/diegosouzapw/OmniRoute/releases/latest" -Headers @{ "User-Agent" = "PowerShell" }).tag_name).TrimStart('v')
# Find latest python
#    $PYTHON_VERSION = ([regex]::Match((Invoke-WebRequest "https://www.python.org/downloads/" -UseBasicParsing).Content, 'Python\s+([0-9]+\.[0-9]+\.[0-9]+)')).Groups[1].Value

$PYTHON_VERSION = "3.14.7"
$CURL_VERSION = "8.22.0_2"
$WGET_VERSION = "1.25.0"
$ARIA_VERSION = "1.37.0"

Set-Location -Path "C:\"
if (-not (Test-Path -Path "C:\temp")) { New-Item -Path "C:\temp" -ItemType Directory }
Set-Location -Path "C:\temp"

# Get 7zip
if (-not (Test-Path -Path "C:\temp\7.zip")) {
    Invoke-WebRequest -Uri "https://www.7-zip.org/a/7za920.zip" -OutFile "C:\temp\7za.zip"
    Invoke-WebRequest -Uri "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-x64.exe" -OutFile "C:\temp\7zip.exe"
#    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\7za.zip" "https://www.7-zip.org/a/7za920.zip"
#    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\7zip.7z" "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-x64.exe"
}

if (-not (Test-Path -Path "C:\temp\7za.exe")) {
    & Expand-Archive -Path "C:\temp\7za.zip" -DestinationPath "C:\temp\7za" -Force
    & "C:\temp\7za\7za.exe" x "C:\temp\7zip.exe" -o"C:\Temp" -y -mmt=on
}

<## Get CURL
if (-not (Test-Path -Path "C:\temp\curl.zip")) {
    Invoke-WebRequest -Uri "https://curl.se/windows/dl-$CURL_VERSION/curl-$CURL_VERSION-win64-mingw.zip" -OutFile "C:\temp\curl.zip"
}

if (-not (Test-Path -Path "C:\temp\curl.exe")) {
    # Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\temp" -Force
    & "C:\temp\7z.exe" x "C:\temp\curl.zip" -o"C:\Temp" -y -mmt=on -bso0 -bsp0
    Move-Item -Path "C:\temp\curl-$CURL_VERSION-win64-mingw\bin\*.*" -Destination "C:\temp" -Force
}

#Get WGET
if (-not (Test-Path -Path "C:\temp\wget.zip")) {
    Invoke-WebRequest -Uri "https://eternallybored.org/misc/wget/releases/wget-$WGET_VERSION-win64.zip" -OutFile "C:\temp\wget.zip"
}

if (-not (Test-Path -Path "C:\temp\wget.exe")) {
    # Expand-Archive -Path "C:\temp\wget.zip" -DestinationPath "C:\temp" -Force
    & "C:\temp\7z.exe" x "C:\temp\wget.zip" -o"C:\Temp" -y -mmt=on -bso0 -bsp0
    #Move-Item -Path "C:\temp\curl-$CURL_VERSION-win64-mingw\bin\*.*" -Destination "C:\temp" -Force
}
#>

#Get ARIA2
if (-not (Test-Path -Path "C:\temp\aria2.zip")) {
    Invoke-WebRequest -Uri "https://github.com/aria2/aria2/releases/download/release-$ARIA_VERSION/aria2-$ARIA_VERSION-win-64bit-build1.zip" -OutFile "C:\temp\aria2.zip"
}

if (-not (Test-Path -Path "C:\temp\aria2c.exe")) {
    # Expand-Archive -Path "C:\temp\aria2.zip" -DestinationPath "C:\temp" -Force
    & "C:\temp\7z.exe" x "C:\temp\aria2.zip" -o"c:\temp" -y -mmt=on -bso0 -bsp0
    Move-Item -Path "C:\temp\aria2-$ARIA_VERSION-win-64bit-build1\*.*" -Destination "C:\temp" -Force
}



#-------------------------- Download VSCode + nodejs ---------------------------
# Define download commands using aria2 only
$UrlsWithNames = @(
    "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
    "  out=vscode.zip"
    "https://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-win-x64.zip"
    "  out=nodejs.zip"
    "https://github.com/git-for-windows/git/releases/download/$GIT_VERSION1/PortableGit-$GIT_VERSION2-64-bit.7z.exe"
    "  out=git.exe"
    "https://github.com/diegosouzapw/OmniRoute/releases/download/v$OMNIROUTE_VERSION/OmniRoute.exe"
    "  out=omniroute.exe"
    "https://github.com/winpython/winpython/releases/download/17.12.20260522/WinPython/WinPython64-$PYTHON_VERSION.0slim.7z"
    "  out=python.7z"

#    "https://https://update.code.visualstudio.com/$VSCODE_VERSION/win32-x64-archive/stable"
#    "  out=vscode.zip"
#    "https://download1.rstudio.org/electron/windows/RStudio-$RSTUDIO_VERSION.zip"
#    "  out=rstudio.zip"
)

$UrlsWithNames | & "c:\temp\aria2c" -j 4 --disable-ipv6=true --allow-overwrite=true --summary-interval=0 -i -






# ----------------- Install VSCode --- ZIP for portable ------------------
<#Write-Output "Downloading VSCode..."
if (-not (Test-Path -Path "C:\temp\RVSCode.zip")) {
    # & "C:\temp\curl.exe" -L --progress-bar -o "C:\temp\RVSCode.zip" "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\vscode.zip" "https://update.code.visualstudio.com/1.97.2/win32-x64-archive/stable"
    # aria2c --disable-ipv6 -x 2 -s 2 -o "VSCode-win32-x64.zip" "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
}
#>

if (-not (Test-Path -Path "C:\VSCode\code.exe")) {
    New-Item -Path "C:\VSCode" -ItemType Directory -Force
    # Expand-Archive -Path "C:\temp\vscode.zip" -DestinationPath "C:\RVSCode"
    & "C:\temp\7zg.exe" x "C:\temp\vscode.zip" -o"C:\VSCode" -y -mmt=on -bso0 -bsp0
}

if (-not (Test-Path -Path "C:\VSCode\nodejs\node.exe")) {
    New-Item -Path "C:\VSCode\nodejs" -ItemType Directory -Force
    # Expand-Archive -Path "C:\temp\vscode.zip" -DestinationPath "C:\RVSCode"
    & "C:\temp\7zg.exe" x "C:\temp\nodejs.zip" -o"C:\temp" -y -mmt=on -bso0 -bsp0
    Move-Item -Path "C:\temp\node-v$NODEJS_VERSION-win-x64\*.*" -Destination "C:\VSCode\nodejs" -Force

}

# Make folders for main course files
New-Item -Path "C:\VSCode\data\user-data\User" -ItemType Directory -Force
New-Item -Path "C:\VSCode\nodejs" -ItemType Directory -Force
New-Item -Path "C:\VSCode\Course\VideCoding" -ItemType Directory -Force

# Copy R to VSCode main folder
#robocopy "$env:ProgramFiles\R" "C:\RVSCode\R" /E /NFL /NDL /NJH /NJS /MT:4

# Set settings.json for R in VSCode
$settingsJson = @"
{
    "r.rpath.windows": "C:\\VSCode\\R\\bin\\\R.exe",
    "editor.dropIntoEditor.preferences": [],
    "r.rterm.option": [
        "--r-binary=C:\\VSCode\\R\\bin\\R.exe",
        "--no-save",
        "--no-restore"
        ],
    "r.rterm.windows": "C:\\VSCode\\R\\bin\\\R.exe",
    "r.bracketedPaste": true,
    "r.sessionWatcher": true,
    "editor.wordSeparators": "`~!@#%$^&*()=+[{]}\\|;:'\",<>/?",
    "r.plot.backend": "auto",
    "r.alwaysUseActiveTerminal": true,
    "editor.hover.enabled": "off",
    "terminal.integrated.env.windows": {"PATH": "${env:PATH};${workspaceFolder}\\nodejs;${workspaceFolder}\\python;${workspaceFolder}\\omniroute;${workspaceFolder}\\git"}
    "git.enabled": true,
    "git.path": "C:\\VSCODE\\Git\\cmd\\git.exe"
    "python.defaultInterpreterPath": "C:\\VSCode\\python\\python.exe"
}
"@
$settingsJson | Out-File -FilePath "C:\VSCode\data\user-data\User\settings.json" -Encoding UTF8

# Add extensions to VSCode
$Code = "C:\VSCode\bin\code.cmd"
$Extensions = @(
    "github.copilot"
    "diegosouzapw.omnicopilot"
    "saoudrizwan.claude-dev"
    "google.geminicode"
    "github.vscode-pull-request-github"
    "ms-python.vscode-pylance"
    "ms-python.python"
    "ms-python.debugpy"
    "ms-python.vscode-python-envs"
#    "Google.google-antigravity"
#    "dbaeumer.vscode-eslint"
#    "esbenp.prettier-vscode"
#    "christian-kohler.npm-intellisense"
#    "humao.rest-client"
#    "editorconfig.editorconfig"
#    "eamodio.gitlens"
#    "SonarSource.sonarlint-vscode"
    )
foreach ($Extension in $Extensions) {
        & $Code --install-extension $Extension --force > $null 2>&1
        }


# Create shortcut link to Desktop
$shell = New-Object -ComObject WScript.Shell
# $desktop = [Environment]::GetFolderPath('Desktop')
$desktop = 'C:\Users\Public\Desktop'
# VSCode shortcut
$vs = $shell.CreateShortcut("$desktop\VSCode.lnk")
$vs.TargetPath = "C:\VSCode\code.exe"
$vs.Arguments = '"C:\VSCode\Course"'
$vs.IconLocation = "C:\VSCode\code.exe,0"
$vs.WorkingDirectory = "C:\VSCode"
$vs.Save()


 #---------------- expand everything else --------------------

    New-Item -Path "C:\VScode\git" -ItemType Directory -Force
    # Expand-Archive -Path "C:\temp\rstudio.zip" -DestinationPath "C:\RStudio"
    & "C:\temp\7z.exe" x "C:\temp\git.exe" -o"C:\VScode\git" -y -mmt=on

    New-Item -Path "C:\VScode\nodejs" -ItemType Directory -Force
    # Expand-Archive -Path "C:\temp\rstudio.zip" -DestinationPath "C:\RStudio"
    & "C:\temp\7z.exe" x "C:\temp\nodejs.zip" -o"C:\VScode\nodejs" -y -mmt=on

    New-Item -Path "C:\VScode\OmniRoute" -ItemType Directory -Force
    Move-Item -Path "C:\temp\OmniRoute*.*" -Destination "C:\VScode\OmniRoute" -Force

    New-Item -Path "C:\VScode\Python" -ItemType Directory -Force
    # Expand-Archive -Path "C:\temp\rstudio.zip" -DestinationPath "C:\RStudio"
    & "C:\temp\7z.exe" x "C:\temp\python.7z" -o"C:\VScode" -y -mmt=on
    Get-ChildItem -Directory -Filter "C:\VScode\WPy64-*" | Select-Object -First 1 | Rename-Item -NewName "python"

<# ---------------- Install RStudio --- ZIP for portable --------------------
<#Write-Output "Downloading RStudio..."
if (-not (Test-Path -Path "C:\temp\rstudio.zip")) {
    # & "C:\temp\curl.exe" --progress-bar -o "C:\temp\rstudio.zip" "https://download1.rstudio.org/electron/windows/RStudio-$RSTUDIO_VERSION.zip"
    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\rstudio.zip" "https://download1.rstudio.org/electron/windows/RStudio-$RSTUDIO_VERSION.zip"
}


<#if (-not (Test-Path -Path "C:\RStudio\rstudio.exe")) {
    New-Item -Path "C:\RStudio" -ItemType Directory -Force
    # Expand-Archive -Path "C:\temp\rstudio.zip" -DestinationPath "C:\RStudio"
    & "C:\temp\7z.exe" x "C:\temp\rstudio.zip" -o"C:\RStudio" -y -mmt=on
}

# Download settings for RStudio
# & "C:\temp\curl.exe" --progress-bar -o "C:\RStudio\user-data\rstudio-prefs.json" "https://drive.usercontent.google.com/download?id=19KaP4pbdM_O78gcgepxqE196SG0zE7fq"
# & "C:\temp\curl.exe" --progress-bar -o "C:\RStudio\user-data\rstudio-desktop.json" "https://drive.usercontent.google.com/download?id=1priqCaKnSOOwCRU5J0anC8mH2gQMQYxE"

# Make folders for RStudio
New-Item -Path "C:\RStudio\Course" -ItemType Directory -Force
New-Item -Path "C:\RStudio\user-data" -ItemType Directory -Force
New-Item -Path "C:\RStudio\resources\stylesheets" -ItemType Directory -Force
New-Item -Path "C:\RStudio\resources\themes" -ItemType Directory -Force


# Copy R to RStudio main folder
& robocopy "C:\RVSCode\R" "C:\RStudio\R" /E /NFL /NDL /NJH /NJS /MT:4

# Set environment variables
$env:RSTUDIO_WHICH_R = ".\R\bin\R.exe"
$env:RSTUDIO_CONFIG_HOME = "C:\RStudio\user-data"
$env:RSTUDIO_DATA_HOME = "C:\RStudio\user-data"
[Environment]::SetEnvironmentVariable("RSTUDIO_WHICH_R", $env:RSTUDIO_WHICH_R, "User")
[Environment]::SetEnvironmentVariable("RSTUDIO_CONFIG_HOME", $env:RSTUDIO_CONFIG_HOME, "User")
[Environment]::SetEnvironmentVariable("RSTUDIO_DATA_HOME", $env:RSTUDIO_DATA_HOME, "User")
# [Environment]::SetEnvironmentVariable("RSTUDIO_WHICH_R", $env:RSTUDIO_WHICH_R, "Machine")
#[Environment]::SetEnvironmentVariable("RSTUDIO_CONFIG_HOME", $env:RSTUDIO_CONFIG_HOME, "Machine")
# [Environment]::SetEnvironmentVariable("RSTUDIO_DATA_HOME", $env:RSTUDIO_DATA_HOME, "Machine")


# Create shortcut link on Desktop
$shell = New-Object -ComObject WScript.Shell
#$desktop = [Environment]::GetFolderPath('Desktop')
$desktop = 'C:\Users\Public\Desktop'
# RStudio shortcut
$rs = $shell.CreateShortcut("$desktop\RStudio.lnk")
$rs.TargetPath = "C:\RStudio\rstudio.exe"
$rs.IconLocation = "C:\RStudio\rstudio.exe,0"
$rs.WorkingDirectory = "C:\RStudio"
$rs.Save()
#>




# -------------------- Cleanup ---------------------------
Write-Output "Cleaning up..."
Remove-Item "C:\temp\*" -Recurse -Force -ErrorAction SilentlyContinue
#>
# Pause for 15 seconds before exiting
Start-Sleep -Seconds 15
