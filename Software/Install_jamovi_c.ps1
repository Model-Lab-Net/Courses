# Title: PowerShell script to install Jamovi
# Author: David Burg
# For: Stats/Econometrics course
# Date: 11/08/2026

# Title: PowerShell script to install Jamovi
# Author: David Burg
# For: Stats/Econometrics course
# Date: 11/08/2026

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
$CURL_VERSION = "8.21.0_6"
$ARIA_VERSION = "1.37.0"
$CURL = "C:\temp\curl.exe"
#$R_VERSION = "4.5.3"
#$RSTUDIO_VERSION = "2026.07.1-147"
#$VSCODE_VERSION = "df53daabb18cd157bdb08c7f01c34df936cf12f4/VSCode-win32-x64-1.132.0.zip"
#$RLANGSERVER_VERSION = "0.3.18"

Set-Location -Path "C:\"
if (-not (Test-Path -Path "C:\temp")) { New-Item -Path "C:\temp" -ItemType Directory }
Set-Location -Path "C:\temp"

if (-not (Test-Path -Path "C:\temp\curl.zip")) {
    Invoke-WebRequest -Uri "https://curl.se/windows/dl-$CURL_VERSION/curl-$CURL_VERSION-win64-mingw.zip" -OutFile "C:\temp\curl.zip"
}
if (-not (Test-Path -Path "C:\temp\curl.exe")) {
    Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\temp"
    Move-Item -Path "C:\temp\curl-$CURL_VERSION-win64-mingw\bin\*.*" -Destination "C:\temp" -Force
}

if (-not (Test-Path -Path "C:\temp\aria.zip")) {
    Invoke-WebRequest -Uri "https://github.com/aria2/aria2/releases/download/release-$ARIA_VERSION/aria2-$ARIA_VERSION-win-64bit-build1.zip" -OutFile "C:\temp\aria.zip"
}
if (-not (Test-Path -Path "C:\temp\aria2.exe")) {
    Expand-Archive -Path "C:\temp\aria.zip" -DestinationPath "C:\temp"
    Move-Item -Path "C:\temp\aria2-$ARIA_VERSION-win-64bit-build1\*.*" -Destination "C:\temp" -Force
}

if (-not (Test-Path -Path "C:\temp\7.zip")) {
    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\7.zip" "https://www.7-zip.org/a/7za920.zip"
}
if (-not (Test-Path -Path "C:\temp\7z.exe")) {
    Expand-Archive -Path "C:\temp\7.zip" -DestinationPath "C:\temp"
}

# -------------------------- Download R ---------------------------
#Write-Output "Downloading R..."
#if (-not (Test-Path -Path "C:\temp\r.exe")) {
#    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\r.exe" "https://cran.r-project.org/bin/windows/base/R-$R_VERSION-win.exe"
#}
#if (-not (Test-Path -Path "c:\RVScode\R\bin")) {
#    Start-Process -Verb RunAs -FilePath "C:\temp\r.exe" -ArgumentList "/SILENT", "/NORESTART", "/MERGETASKS=!desktopicon", "/SP-", "/DIR=`"c:\RVScode\R`"" -Wait
#}
#Copy-Item -Path "c:\RVScode\R\bin\x64\Rblas.dll" -Destination "c:\RVScode\R\library\stats\libs\x64" -Force
#Copy-Item -Path "c:\RVScode\R\bin\x64\Rlapack.dll" -Destination "c:\RVScode\R\library\stats\libs\x64" -Force

# ----------------- Download Jamovi --- EXE for install ------------------
Write-Output "Downloading Jamovi..."
$JAMOVI_VERSION = "28.3.0.0"
$curlOptions = @(
    "--progress-bar", "-L"
    "-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0"
    "-e", "https://www.jamovi.org/"
    "-H", "Accept: */*"
    "-H", "Accept-Language: en-US,en;q=0.9"
    "-o"
)

if (-not (Test-Path -Path "C:\Jamovi")) {
    New-Item -Path "C:\Jamovi" -ItemType Directory -Force
    New-Item -Path "C:\Jamovi\Course" -ItemType Directory -Force
}

if (-not (Test-Path -Path "C:\temp\jamovi.exe")) {
    & "C:\temp\curl.exe" @curlOptions "C:\temp\jamovi.zip" "https://dl-cdn.jamovi.org/jamovi-$JAMOVI_VERSION-win-x64.zip"
#   & "C:\temp\curl.exe" --progress-bar -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36" -e "https://www.jamovi.org/" -o "C:\temp\jamovi.zip" "https://dl-cdn.jamovi.org/jamovi-28.1.0.0-win-x64.zip"
    Expand-Archive -Path "C:\temp\jamovi.zip" -DestinationPath "C:\"
}


# Make folders for main course files
#New-Item -Path "C:\RVSCode\data\user-data\User" -ItemType Directory -Force
#New-Item -Path "C:\RVSCode\R" -ItemType Directory -Force
#New-Item -Path "C:\RVSCode\Course\EpiCode" -ItemType Directory -Force
#New-Item -Path "C:\RVSCode\Course\EpiData" -ItemType Directory -Force

# Copy R to VSCode main folder
#robocopy "$env:ProgramFiles\R" "C:\RVSCode\R" /E /NFL /NDL /NJH /NJS /MT:4



# -------------------- Add Jamovi modules ---------------------------
#https://library.jamovi.org/win64/R4.6.0-x64/
$curlOptions = @(
    "--progress-bar", "-L"
    "-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0"
    "-e", "https://library.jamovi.org/"
    "-H", "Accept: */*"
    "-H", "Accept-Language: en-US,en;q=0.9"
    "-o"
)

$JMO_VERSION = "4.6.0"
#$rdatasets = "1.0.1"
#$lsj = "1.0.1"
#$GAMLj3 = "3.7.1"
#$RJ = "2.7.18"
#$ESCI = "1.0.10"
#$MORETETS = "0.9.5"
#$SEMLJ = "1.2.8"
#$snowCluster = "7.6.8"
#$jsurvival = "1.0.6"
#$flexplot = "0.7.2"

$modules = @(
    @{ Name = "r-datasets";  Version = "1.0.1" }
    @{ Name = "lsj-data";    Version = "1.0.1" }
    @{ Name = "GAMLj3";      Version = "3.7.1" }
    @{ Name = "Rj";          Version = "2.7.18" }
    @{ Name = "esci";        Version = "1.0.10" }
    @{ Name = "moretests";   Version = "0.9.5" }
    @{ Name = "semlj";       Version = "1.2.8" }
    @{ Name = "snowCluster"; Version = "7.6.8" }
    @{ Name = "jsurvival";   Version = "1.0.6" }
    @{ Name = "flexplot";    Version = "0.7.2" }
)

$destPath = "$env:AppData\jamovi\modules"
$curlExe  = "C:\temp\curl.exe"

foreach ($module in $modules) {
    $name    = $module.Name
    $version = $module.Version

    Write-Output "Adding module - $name..."

    $zipFile = "C:\temp\$name.zip"
    $url     = "https://library.jamovi.org/win64/R$JMO_VERSION-x64/$name-$version.jmo"

    & $curlExe @curlOptions $zipFile $url
    Expand-Archive -Path $zipFile -DestinationPath $destPath -Force
}



# -------------------- Add R packages for Rj ---------------------------

Write-Output "Adding R packages to Jamovi..."

$RScriptPath = "C:\jamovi\Frameworks\R\bin\RScript.exe"

$Packages = @('gtsummary', 'AER', 'DescTools', 'skedastic', 'sandwich',
              'modelbased', 'VGAM', 'car', 'jmvconnect', 'performance',
              'parameters', 'systemfit', 'quantreg', 'merTools',
              'MCMCpack', 'bayestestR', 'coda'
              )

# Joins the packages into a single R vector string: c('pkg1', 'pkg2', ...)
$RVector = "c(" + (($Packages | ForEach-Object { "'$_'" }) -join ", ") + ")"

# Executes the installation in a single R process
& $RScriptPath -e "install.packages($RVector, repos='https://cloud.r-project.org', force=TRUE)"


# -------------------- Create shorcut ---------------------------

# Create shortcut link to Desktop
$shell = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
# VSCode shortcut
$vs = $shell.CreateShortcut("$desktop\Jamovi.lnk")
$vs.TargetPath = "C:\Jamovi\bin\jamovi.exe"
#$vs.Arguments = '"C:\Jamovi\Course"'
$vs.IconLocation = "C:\Jamovi\bin\jamovi.exe"
$vs.WorkingDirectory = "C:\Jamovi\bin"
$vs.Save()



# -------------------- Uninstall R and cleanup ---------------------------

Write-Output "Cleaning up..."
Remove-Item "C:\temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Pause for 15 seconds before exiting
Start-Sleep -Seconds 15


