# Title: PowerShell script to install GPower
# Author: David Burg
# For: Stats/Econometrics course
# Date: 24/08/2026


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
$BS_VERSION = "10.3.4"
$CURL_VERSION = "8.21.0_6"
$ARIA_VERSION = "1.37.0"
$CURL = "C:\temp\curl.exe"

Set-Location -Path "C:\"
if (-not (Test-Path -Path "C:\temp")) { New-Item -Path "C:\temp" -ItemType Directory }
Set-Location -Path "C:\temp"

# Get 7zip
if (-not (Test-Path -Path "C:\temp\7.zip")) {
    Invoke-WebRequest -Uri "https://www.7-zip.org/a/7za920.zip" -OutFile "C:\temp\7za.zip"
    Invoke-WebRequest -Uri "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-x64.exe" -OutFile "C:\temp\7zip.exe"
    #& "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\7za.zip" "https://www.7-zip.org/a/7za920.zip"
    #& "C:\temp\wget.exe" --no-verbose --show-progress -O "C:\temp\7zip.7z" "https://github.com/ip7z/7zip/releases/download/26.03/7z2603-x64.exe"
}

if (-not (Test-Path -Path "C:\temp\7za.exe")) {
    & Expand-Archive -Path "C:\temp\7za.zip" -DestinationPath "C:\temp\7za" -Force
    & "C:\temp\7za\7za.exe" x "C:\temp\7zip.exe" -o"C:\Temp" -y -mmt=on
}

# Get curl
if (-not (Test-Path -Path "C:\temp\curl.zip")) {
    Invoke-WebRequest -Uri "https://curl.se/windows/dl-$CURL_VERSION/curl-$CURL_VERSION-win64-mingw.zip" -OutFile "C:\temp\curl.zip"
}
if (-not (Test-Path -Path "C:\temp\curl.exe")) {
    Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\temp" -Force
    Move-Item -Path "C:\temp\curl-$CURL_VERSION-win64-mingw\bin\*.*" -Destination "C:\temp" -Force
}

# Get aria
if (-not (Test-Path -Path "C:\temp\aria.zip")) {
    Invoke-WebRequest -Uri "https://github.com/aria2/aria2/releases/download/release-$ARIA_VERSION/aria2-$ARIA_VERSION-win-64bit-build1.zip" -OutFile "C:\temp\aria.zip"
}
if (-not (Test-Path -Path "C:\temp\aria2.exe")) {
    Expand-Archive -Path "C:\temp\aria.zip" -DestinationPath "C:\temp" -Force
    Move-Item -Path "C:\temp\aria2-$ARIA_VERSION-win-64bit-build1\*.*" -Destination "C:\temp" -Force
}


# ----------------- Download GPower --- and install ------------------
Write-Output "Downloading BlueSky..."
$curlOptions = @(
    "--progress-bar"
    "--ssl-no-revoke",
    "-O"
)

if (-not (Test-Path -Path "C:\BlueSky")) {
    New-Item -Path "C:\BlueSky" -ItemType Directory -Force
    }

if (-not (Test-Path -Path "C:\temp\bluesky.exe")) {
    C:\temp\curl.exe --ssl-no-revoke -o "C:\temp\BlueSky.exe" "https://www.blueskystat.net/v${BS_VERSION}WinOpn/BlueSky%20Statistics-v$BS_VERSION.exe"
    & "C:\temp\7zg.exe" x "C:\temp\bluesky.exe" -o"c:\temp\bs" -y -mmt=on -bso0 -bsp0
    & "C:\temp\7zg.exe" x 'C:\temp\bs\$PLUGINSDIR\app-64.7z' -o"C:\BlueSky" -y -mmt=on -bso0 -bsp0

}


# -------------------- Create shorcut ---------------------------

# Create shortcut link to Desktop
$shell = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
# VSCode shortcut
$vs = $shell.CreateShortcut("$desktop\BlueSky.lnk")
$vs.TargetPath = "C:\BlueSky\BlueSky Statistics.exe"
#$vs.Arguments = '"C:\GPower\Course"'
$vs.IconLocation = "C:\BlueSky\BlueSky Statistics.exe"
$vs.WorkingDirectory = "C:\BlueSky"
$vs.Save()



# -------------------- Uninstall and cleanup ---------------------------

Write-Output "Cleaning up..."
Remove-Item "C:\temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Pause for 15 seconds before exiting
Start-Sleep -Seconds 15
