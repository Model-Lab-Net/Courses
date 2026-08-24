# Title: PowerShell script to install GPower
# Author: David Burg
# For: Stats/Econometrics course
# Date: 24/08/2026

# ---------------------- Get everything ready -------------------------------
$GP_VERSION = "3.1.9.7"
$CURL_VERSION = "8.21.0_6"
$ARIA_VERSION = "1.37.0"
$CURL = "C:\temp\curl.exe"

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

# ----------------- Download GPower --- and install ------------------
Write-Output "Downloading GPower..."
$curlOptions = @(
    "--progress-bar"
    "--location"
    "--insecure",
    "--fail",
    "-o"
)

if (-not (Test-Path -Path "C:\GPower")) {
    New-Item -Path "C:\GPower" -ItemType Directory -Force
    }

if (-not (Test-Path -Path "C:\temp\gpower.zip")) {
    C:\temp\curl.exe @curlOptions "C:\temp\gpower.zip" "https://www.psychologie.hhu.de/fileadmin/redaktion/Fakultaeten/Mathematisch-Naturwissenschaftliche_Fakultaet/Psychologie/AAP/gpower/GPowerWin_$GP_VERSION.zip"
    Expand-Archive -Path "C:\temp\gpower.zip" -DestinationPath "C:\"
    Rename-Item "c:\GPower_3.1.9.7_143" "C:\GPower"
}


# -------------------- Create shorcut ---------------------------

# Create shortcut link to Desktop
$shell = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
# VSCode shortcut
$vs = $shell.CreateShortcut("$desktop\GPower.lnk")
$vs.TargetPath = "C:\GPower\GPowerNT.exe"
#$vs.Arguments = '"C:\GPower\Course"'
$vs.IconLocation = "C:\GPower\GPowerNT.exe"
$vs.WorkingDirectory = "C:\GPower"
$vs.Save()



# -------------------- Uninstall and cleanup ---------------------------

Write-Output "Cleaning up..."
Remove-Item "C:\temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Pause for 15 seconds before exiting
Start-Sleep -Seconds 15
