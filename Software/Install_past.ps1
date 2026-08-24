# Title: PowerShell script to install PAST
# Author: David Burg
# For: Stats/Econometrics course
# Date: 24/08/2026

# ---------------------- Get everything ready -------------------------------
$PAST_VERSION = "5.3"
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
    Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\temp" -Force
    Move-Item -Path "C:\temp\curl-$CURL_VERSION-win64-mingw\bin\*.*" -Destination "C:\temp" -Force
}

if (-not (Test-Path -Path "C:\temp\aria.zip")) {
    Invoke-WebRequest -Uri "https://github.com/aria2/aria2/releases/download/release-$ARIA_VERSION/aria2-$ARIA_VERSION-win-64bit-build1.zip" -OutFile "C:\temp\aria.zip"
}
if (-not (Test-Path -Path "C:\temp\aria2.exe")) {
    Expand-Archive -Path "C:\temp\aria.zip" -DestinationPath "C:\temp" -Force
    Move-Item -Path "C:\temp\aria2-$ARIA_VERSION-win-64bit-build1\*.*" -Destination "C:\temp" -Force
}

if (-not (Test-Path -Path "C:\temp\7.zip")) {
    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\7.zip" "https://www.7-zip.org/a/7za920.zip"
}
if (-not (Test-Path -Path "C:\temp\7z.exe")) {
    Expand-Archive -Path "C:\temp\7.zip" -DestinationPath "C:\temp" -Force
}

# ----------------- Download PAST --- and install ------------------
Write-Output "Downloading PAST..."
$curlOptions = @(
    "--progress-bar", "-L",
    "-k",
    "-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0",
    "-e", "https://www.nhm.uio.no/english/research/resources/past/",
    "-H", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
#    "-H", "Accept-Language: en-US,en;q=0.9"
    "-o"
)

if (-not (Test-Path -Path "C:\PAST")) {
    New-Item -Path "C:\PAST" -ItemType Directory -Force
    New-Item -Path "C:\PAST\Course" -ItemType Directory -Force
}

if (-not (Test-Path -Path "C:\temp\past.zip")) {
    C:\temp\curl.exe @curlOptions "C:\temp\past.zip" "https://www.nhm.uio.no/english/research/resources/past/downloads/pastsetup$PAST_VERSION.zip"
    Expand-Archive -Path "C:\temp\past.zip" -DestinationPath "C:\temp" -Force
    Start-Process -FilePath "C:\temp\pastsetup$PAST_VERSION.exe" -ArgumentList '/VERYSILENT', '/SP-', '/NORESTART', '/DIR="C:\PAST"' -Wait
}

#curl -L -o "$ENV:UserProfile\Downloads\gretl.zip" "https://downloads.sourceforge.net/project/gretl/gretl/2026a/gretl-2026a-win64.zip"


# Make folders for main course files
#New-Item -Path "C:\RVSCode\data\user-data\User" -ItemType Directory -Force
#New-Item -Path "C:\RVSCode\R" -ItemType Directory -Force
#New-Item -Path "C:\RVSCode\Course\EpiCode" -ItemType Directory -Force
#New-Item -Path "C:\RVSCode\Course\EpiData" -ItemType Directory -Force

# Copy R to VSCode main folder
#robocopy "$env:ProgramFiles\R" "C:\RVSCode\R" /E /NFL /NDL /NJH /NJS /MT:4




# -------------------- Create shorcut ---------------------------

# Create shortcut link to Desktop
$shell = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
# VSCode shortcut
$vs = $shell.CreateShortcut("$desktop\PAST.lnk")
$vs.TargetPath = "C:\PAST\Past5.exe"
#$vs.Arguments = '"C:\Jamovi\Course"'
$vs.IconLocation = "C:\PAST\Past5.exe"
$vs.WorkingDirectory = "C:\PAST"
$vs.Save()



# -------------------- Uninstall and cleanup ---------------------------

Write-Output "Cleaning up..."
Remove-Item "C:\temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Pause for 15 seconds before exiting
Start-Sleep -Seconds 15
