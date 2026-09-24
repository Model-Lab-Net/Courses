# Title: PowerShell script to install R, RStudio, and R in VSCode
# Author: David Burg
# For: R course
# Date: 25/09/2026
# Source: https://www.youtube.com/watch?v=k79H8EeR5Jo
#         https://www.youtube.com/watch?v=rKPfssR66GM
#         https://www.datanovia.com/learn/tools/r-in-vscode/recommended-vscode-configurations-for-r-programming.html
#         ...things have changes since these tutorials. Now use jpd() and sess().


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
$R_VERSION = "4.6.1"
$RSTUDIO_VERSION = "2026.09.0-174"
$VSCODE_VERSION = "1.139.0"
$CURL_VERSION = "8.22.0_2"
$WGET_VERSION = "1.21.4"
$ARIA_VERSION = "1.37.0"

Set-Location -Path "C:\"
if (-not (Test-Path -Path "C:\temp")) { New-Item -Path "C:\temp" -ItemType Directory }
Set-Location -Path "C:\temp"

# Get 7zip
if (-not (Test-Path -Path "C:\temp\7.zip")) {
    Invoke-WebRequest -Uri "https://www.7-zip.org/a/7za920.zip" -OutFile "C:\temp\7za.zip"
    Invoke-WebRequest -Uri "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-x64.exe" -OutFile "C:\temp\7zip.exe"
    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\7za.zip" "https://www.7-zip.org/a/7za920.zip"
    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\7zip.7z" "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-x64.exe"
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

if (-not (Test-Path -Path "C:\temp\aria2.zip")) {
    # Expand-Archive -Path "C:\temp\aria2.zip" -DestinationPath "C:\temp" -Force
    & "C:\temp\7z.exe" x "C:\temp\aria2.zip" -o"c:\temp" -y -mmt=on -bso0 -bsp0
    Move-Item -Path "C:\temp\aria2-$ARIA_VERSION-win-64bit-build1\*.*" -Destination "C:\temp" -Force
}



#-------------------------- Download R + VSCode ---------------------------
# Define download commands using aria2 only
$UrlsWithNames = @(
    "https://cran.r-project.org/bin/windows/base/old/$R_VERSION/R-$R_VERSION-win.exe"
    "  out=r.exe"
    "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
    "  out=vscode.zip"
#    "https://https://update.code.visualstudio.com/$VSCODE_VERSION/win32-x64-archive/stable"
#    "  out=vscode.zip"
#    "https://download1.rstudio.org/electron/windows/RStudio-$RSTUDIO_VERSION.zip"
#    "  out=rstudio.zip"
)

$UrlsWithNames | & "c:\temp\aria2c" -j 4 --disable-ipv6=true --allow-overwrite=true --summary-interval=0 -i -





# -------------------------- Install R ---------------------------
<#Write-Output "Downloading R..."
if (-not (Test-Path -Path "C:\temp\r.exe")) {
    # & "C:\temp\curl.exe" --progress-bar -o "C:\temp\r.exe" "https://cran.r-project.org/bin/windows/base/old/$R_VERSION/R-$R_VERSION-win.exe"
    # & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\r.exe" "https://cran.r-project.org/bin/windows/base/old/$R_VERSION/R-$R_VERSION-win.exe"
}
#>

if (-not (Test-Path -Path "c:\RVSCode\R\bin")) {
    Start-Process -Verb RunAs -FilePath "C:\temp\r.exe" -ArgumentList "/SILENT", "/NORESTART", "/MERGETASKS=!desktopicon", "/SP-", "/DIR=`"c:\RVSCode\R`"" -Wait
}

Copy-Item -Path "c:\RVSCode\R\bin\Rblas.dll" -Destination "c:\RVSCode\R\library\stats\libs" -Force
Copy-Item -Path "c:\RVSCode\R\bin\Rlapack.dll" -Destination "c:\RVSCode\R\library\stats\libs" -Force
Copy-Item -Path "c:\RVSCode\R\bin\x64\Rblas.dll" -Destination "c:\RVSCode\R\library\stats\x64\libs" -Force
Copy-Item -Path "c:\RVSCode\R\bin\x64\Rlapack.dll" -Destination "c:\RVSCode\R\library\stats\x64\libs" -Force

& "C:\RVSCode\R\bin\R.exe" -e "install.packages('languageserver', repos='https://cloud.r-project.org')"
& "C:\RVSCode\R\bin\R.exe" -e "install.packages('jgd', repos='https://cloud.r-project.org)"
& "C:\RVSCode\R\bin\R.exe" -e "install.packages('vscDebugger', repos = 'https://manuelhentschel.r-universe.dev')"

& "C:\RVSCode\R\bin\R.exe" -e "install.packages('remotes', repos='https://cloud.r-project.org')"
& "C:\RVSCode\R\bin\R.exe" -e "remotes::install_github("REditorSupport/vscode-R/sess")"

# ----------------- Install VSCode --- ZIP for portable ------------------
<#Write-Output "Downloading VSCode..."
if (-not (Test-Path -Path "C:\temp\RVSCode.zip")) {
    # & "C:\temp\curl.exe" -L --progress-bar -o "C:\temp\RVSCode.zip" "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\vscode.zip" "https://update.code.visualstudio.com/1.97.2/win32-x64-archive/stable"
    # aria2c --disable-ipv6 -x 2 -s 2 -o "VSCode-win32-x64.zip" "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
}
#>

if (-not (Test-Path -Path "C:\RVSCode\code.exe")) {
    New-Item -Path "C:\RVSCode" -ItemType Directory -Force
    # Expand-Archive -Path "C:\temp\vscode.zip" -DestinationPath "C:\RVSCode"
    & "C:\temp\7zg.exe" x "C:\temp\vscode.zip" -o"C:\RVSCode" -y -mmt=on -bso0 -bsp0
}

# Make folders for main course files
New-Item -Path "C:\RVSCode\data\user-data\User" -ItemType Directory -Force
New-Item -Path "C:\RVSCode\R" -ItemType Directory -Force
New-Item -Path "C:\RVSCode\Course\EpiCode" -ItemType Directory -Force
New-Item -Path "C:\RVSCode\Course\EpiData" -ItemType Directory -Force

# Copy R to VSCode main folder
#robocopy "$env:ProgramFiles\R" "C:\RVSCode\R" /E /NFL /NDL /NJH /NJS /MT:4

# Set settings.json for R in VSCode
$settingsJson = @"
{
    "r.rpath.windows": "C:\\RVSCode\\R\\bin\\\R.exe",
    "editor.dropIntoEditor.preferences": [],
    "r.rterm.option": [
        "--r-binary=C:\\RVSCode\\R\\bin\\R.exe",
        "--no-save",
        "--no-restore"
    ],
    "r.rterm.windows": "C:\\RVSCode\\R\\bin\\\R.exe",
    "r.bracketedPaste": true,
    "r.sessionWatcher": true,
    "editor.wordSeparators": "`~!@#%$^&*()-=+[{]}\\|;:'\",<>/?",
    "r.plot.backend": "auto",
    "r.alwaysUseActiveTerminal": true,
    "editor.hover.enabled": "off"
}
"@
$settingsJson | Out-File -FilePath "C:\RVSCode\data\user-data\User\settings.json" -Encoding UTF8

# Add extensions to VSCode
& "C:\RVSCode\bin\code.cmd" --install-extension github.copilot --force > $null 2>&1
# & "C:\RVSCode\bin\code.exe" --install-extension github.copilot-chat
    & "c:\temp\curl.exe" -L "https://github.com/REditorSupport/vscode-R/releases/download/latest/vscode-R.vsix" -o "c:\temp\vscode-R.vsix"
    & "C:\RVSCode\bin\code.cmd" --install-extension "c:\temp\vscode-R.vsix" --force
& "C:\RVSCode\bin\code.cmd" --install-extension rdebugger.r-debugger --force > $null 2>&1
& "C:\RVSCode\bin\code.cmd" --install-extension rlang.r --force > $null 2>&1

# Download first script to initialize for course
& "C:\temp\curl.exe" --progress-bar -o "C:\RVSCode\Course\Initialize_R.Rmd" "https://raw.githubusercontent.com/Model-Lab-Net/Courses/refs/heads/main/Epi/!Initialize_R_for_Epi.Rmd"
#& "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\RVSCode\Course\Initialize_R.Rmd" "https://raw.githubusercontent.com/Model-Lab-Net/Courses/refs/heads/main/Epi/!Initialize_R_for_Epi.Rmd"

# Create shortcut link to Desktop
$shell = New-Object -ComObject WScript.Shell
# $desktop = [Environment]::GetFolderPath('Desktop')
$desktop = 'C:\Users\Public\Desktop'
# VSCode shortcut
$vs = $shell.CreateShortcut("$desktop\RVSCode.lnk")
$vs.TargetPath = "C:\RVSCode\code.exe"
$vs.Arguments = '"C:\RVSCode\Course"'
$vs.IconLocation = "C:\RVSCode\code.exe,0"
$vs.WorkingDirectory = "C:\RVSCode"
$vs.Save()

<# ---------------- Install RStudio --- ZIP for portable --------------------
<#Write-Output "Downloading RStudio..."
if (-not (Test-Path -Path "C:\temp\rstudio.zip")) {
    # & "C:\temp\curl.exe" --progress-bar -o "C:\temp\rstudio.zip" "https://download1.rstudio.org/electron/windows/RStudio-$RSTUDIO_VERSION.zip"
    & "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\rstudio.zip" "https://download1.rstudio.org/electron/windows/RStudio-$RSTUDIO_VERSION.zip"
}
#>

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

# Pause for 15 seconds before exiting
Start-Sleep -Seconds 15
