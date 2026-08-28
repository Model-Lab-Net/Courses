# Title: PowerShell script to install Jamovi
# Author: David Burg
# For: Stats/Econometrics course
# Date: 11/08/2026

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

# ----------------- Download Jamovi --- ZIP for portable ------------------
Write-Output "Downloading Jamovi..."
$JAMOVI_VERSION = "28.1.0.0"
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

if (-not (Test-Path -Path "C:\temp\jamovi.zip")) {
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
$JMO_VERSION = "4.6.0"
$rdatasets = "1.0.1"
$lsj = "1.0.1"
$GAMLj3 = "3.7.0"
$RJ = "2.7.18"
$ESCI = "1.0.10"
$MORETETS = "0.9.5"
$SEMLJ = "1.2.5"
$snowCluster = "7.6.8"
$jsurvival = "1.0.0"
$flexplot = "0.7.2"
$curlOptions = @(
    "--progress-bar", "-L"
    "-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0"
    "-e", "https://library.jamovi.org/"
    "-H", "Accept: */*"
    "-H", "Accept-Language: en-US,en;q=0.9"
    "-o"
)

#curl.exe -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 OPR/133.0.0.0" -e "https://library.jamovi.org/" -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.9" -o "r-datasets.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/r-datasets-$rdatasets.jmo"
Write-Output "Adding module - r-datasets..."
C:\temp\curl.exe @curlOptions "C:\temp\r-datasets.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/r-datasets-$rdatasets.jmo"
Expand-Archive -Path "C:\temp\r-datasets.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - lsj-data..."
curl.exe @curlOptions "C:\temp\lsj-data.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/lsj-data-$lsj.jmo"
Expand-Archive -Path "C:\temp\lsj-data.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - GAMLj3..."
C:\temp\curl.exe @curlOptions "C:\temp\GAMLj3.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/GAMLj3-$GAMLj3.jmo"
Expand-Archive -Path "C:\temp\GAMLj3.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - Rj..."
C:\temp\curl.exe @curlOptions "C:\temp\Rj.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/Rj-$RJ.jmo"
Expand-Archive -Path "C:\temp\Rj.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - esci..."
C:\temp\curl.exe @curlOptions "C:\temp\esci.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/esci-$esci.jmo"
Expand-Archive -Path "C:\temp\esci.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - moretests..."
C:\temp\curl.exe @curlOptions "C:\temp\moretests.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/moretests-$MORETETS.jmo"
Expand-Archive -Path "C:\temp\moretests.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - semlj..."
C:\temp\curl.exe @curlOptions "C:\temp\semlj.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/semlj-$SEMLJ.jmo"
Expand-Archive -Path "C:\temp\semlj.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - snowCluster..."
C:\temp\curl.exe @curlOptions "C:\temp\snowCluster.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/snowCluster-$snowCluster.jmo"
Expand-Archive -Path "C:\temp\snowCluster.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - jsurvival..."
C:\temp\curl.exe @curlOptions "C:\temp\jsurvival.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/jsurvival-$jsurvival.jmo"
Expand-Archive -Path "C:\temp\jsurvival.zip" -DestinationPath "C:\Jamovi\Resources\modules"

Write-Output "Adding module - flexplot..."
C:\temp\curl.exe @curlOptions "C:\temp\flexplot.zip" "https://library.jamovi.org/win64/R$JMO_VERSION-x64/flexplot-$flexplot.jmo"
Expand-Archive -Path "C:\temp\flexplot.zip" -DestinationPath "C:\Jamovi\Resources\modules"




# -------------------- Add packages for Jamovi's Rj ---------------------------

C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('AER', repos='https://cloud.r-project.org', force=TRUE)"
C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('DescTools', repos='https://cloud.r-project.org', force=TRUE)"
C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('VGAM', repos='https://cloud.r-project.org', force=TRUE)"
C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('car', repos='https://cloud.r-project.org', force=TRUE)"
C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('jmvconnect', repos='https://cloud.r-project.org', force=TRUE)"
C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('skedastic', repos='https://cloud.r-project.org', force=TRUE)"
C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('systemfit', repos='https://cloud.r-project.org', force=TRUE)"
C:\Jamovi\Frameworks\R\bin\RScript.exe -e "install.packages('quantreg', repos='https://cloud.r-project.org', force=TRUE)"



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
