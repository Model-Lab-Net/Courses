# Title: PowerShell script to install R, RStudio, and R in VSCode
# Author: David Burg
# For: R course
# Date: 20/07/2025
# Source: https://www.youtube.com/watch?v=k79H8EeR5Jo
#         https://www.youtube.com/watch?v=rKPfssR66GM
#         https://www.datanovia.com/learn/tools/r-in-vscode/recommended-vscode-configurations-for-r-programming.html

# ---------------------- Get everything ready -------------------------------
$R_VERSION = "4.5.1"
$RSTUDIO_VERSION = "2025.05.0-496"
$VSCODE_VERSION = "2901c5ac6db8a986a5666c3af51ff804d05af0d4/VSCode-win32-x64-1.101.2.zip"
$RLANGSERVER_VERSION = "0.3.16"
$CURL_VERSION = "8.14.1_2"

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

if (-not (Test-Path -Path "C:\temp\7.zip")) {
    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\7.zip" "https://www.7-zip.org/a/7za920.zip"
}
if (-not (Test-Path -Path "C:\temp\7z.exe")) {
    Expand-Archive -Path "C:\temp\7.zip" -DestinationPath "C:\temp"
}

# -------------------------- Download R ---------------------------
Write-Output "Downloading R..."
if (-not (Test-Path -Path "C:\temp\r.exe")) {
    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\r.exe" "https://cran.r-project.org/bin/windows/base/R-$R_VERSION-win.exe"
}
if (-not (Test-Path -Path "$env:ProgramFiles\R\R-$R_VERSION\bin")) {
    Start-Process -FilePath "C:\temp\r.exe" -ArgumentList "/VERYSILENT", "/NORESTART", "/SP-" -Wait
}
Copy-Item -Path "$env:ProgramFiles\R\R-$R_VERSION\bin\x64\Rblas.dll" -Destination "$env:ProgramFiles\R\R-$R_VERSION\library\stats\libs\x64" -Force
Copy-Item -Path "$env:ProgramFiles\R\R-$R_VERSION\bin\x64\Rlapack.dll" -Destination "$env:ProgramFiles\R\R-$R_VERSION\library\stats\libs\x64" -Force

# ----------------- Download VSCode --- ZIP for portable ------------------
Write-Output "Downloading VSCode..."
if (-not (Test-Path -Path "C:\temp\rvscode.zip")) {
    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\rvscode.zip" "https://vscode.download.prss.microsoft.com/dbazure/download/stable/$VSCODE_VERSION"
}
if (-not (Test-Path -Path "C:\RVSCode\code.exe")) {
    New-Item -Path "C:\RVSCode" -ItemType Directory -Force
    Expand-Archive -Path "C:\temp\rvscode.zip" -DestinationPath "C:\RVSCode"
}

# Make folders for main course files
New-Item -Path "C:\RVSCode\data\user-data\User" -ItemType Directory -Force
New-Item -Path "C:\RVSCode\R" -ItemType Directory -Force
New-Item -Path "C:\RVSCode\Course\EpiCode" -ItemType Directory -Force
New-Item -Path "C:\RVSCode\Course\EpiData" -ItemType Directory -Force

# Copy R to VSCode main folder
robocopy "$env:ProgramFiles\R" "C:\RVSCode\R" /E /NFL /NDL /NJH /NJS /MT:4

# Install R languageserver package
if (-not (Test-Path -Path "C:\temp\languageserver.zip")) {
    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\languageserver.zip" "https://cran.r-project.org/bin/windows/contrib/4.6/languageserver_$RLANGSERVER_VERSION.zip"
}
& "C:\RVSCode\R\R-$R_VERSION\bin\R.exe" CMD INSTALL "C:\temp\languageserver.zip"

# Set settings.json for R in VSCode
$settingsJson = @"
{
    "r.rpath.windows": "C:\\RVSCode\\R\\R-$R_VERSION\\bin\\R.exe",
    "editor.dropIntoEditor.preferences": [],
    "r.rterm.option": [
        "--r-binary=C:\\RVSCode\\R\\R-$R_VERSION\\bin\\R.exe",
        "--no-save",
        "--no-restore"
    ],
    "r.rterm.windows": "C:\\RVSCode\\R\\R-$R_VERSION\\bin\\R.exe",
    "r.bracketedPaste": true,
    "r.sessionWatcher": true,
    "editor.wordSeparators": "`~!@#%$^&*()-=+[{]}\\|;:'\",<>/?",
    "r.plot.useHttpgd": true,
    "terminal.integrated.profiles.windows": {
        "R": {
            "path": "C:\\RVSCode\\R\\R-$R_VERSION\\bin\\R.exe",
            "args": [ "--no-save", "--no-restore" ],
            "env": {
                "PATH": "C:\\RVSCode\\R\\R-$R_VERSION\\bin"
            }
        }
    }
}
"@
$settingsJson | Out-File -FilePath "C:\RVSCode\data\user-data\User\settings.json" -Encoding UTF8

# Add extensions to VSCode
& "C:\RVSCode\bin\code.cmd" --install-extension github.copilot
# & "C:\RVSCode\bin\code.cmd" --install-extension github.copilot-chat
& "C:\RVSCode\bin\code.cmd" --install-extension reditorsupport.r
& "C:\RVSCode\bin\code.cmd" --install-extension rdebugger.r-debugger

# Download first script to initialize for course
& "C:\temp\curl.exe" --progress-bar -o "C:\RVSCode\Course\Initialize_R.Rmd" "https://raw.githubusercontent.com/Model-Lab-Net/Courses/refs/heads/main/Epi/!Initialize_R.Rmd"

# Create shortcut link to Desktop
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("$env:ALLUSERSPROFILE\Desktop\RVSCode.lnk")
$shortcut.TargetPath = "C:\RVSCode\code.exe"
$shortcut.Arguments = '"C:\RVScode\Course"'
$shortcut.IconLocation = "C:\RVSCode\code.exe,0"
$shortcut.Save()

# ---------------- Download RStudio --- ZIP for portable --------------------
Write-Output "Downloading RStudio..."
if (-not (Test-Path -Path "C:\temp\rstudio.zip")) {
    & "C:\temp\curl.exe" --progress-bar -o "C:\temp\rstudio.zip" "https://download1.rstudio.org/electron/windows/RStudio-$RSTUDIO_VERSION.zip"
}
if (-not (Test-Path -Path "C:\RStudio\rstudio.exe")) {
    New-Item -Path "C:\RStudio" -ItemType Directory -Force
    Expand-Archive -Path "C:\temp\rstudio.zip" -DestinationPath "C:\RStudio"
}

# Download settings for RStudio
& "C:\temp\curl.exe" --progress-bar -o "C:\RStudio\user-data\rstudio-prefs.json" "https://drive.usercontent.google.com/download?id=19KaP4pbdM_O78gcgepxqE196SG0zE7fq"
& "C:\temp\curl.exe" --progress-bar -o "C:\RStudio\user-data\rstudio-desktop.json" "https://drive.usercontent.google.com/download?id=1priqCaKnSOOwCRU5J0anC8mH2gQMQYxE"

# Make folders for RStudio
New-Item -Path "C:\RStudio\Course" -ItemType Directory -Force
New-Item -Path "C:\RStudio\user-data" -ItemType Directory -Force

# Copy R to RStudio main folder
robocopy "$env:ProgramFiles\R" "C:\RStudio\R" /E /NFL /NDL /NJH /NJS /MT:4

# Set environment variables
$env:RSTUDIO_WHICH_R = ".\R\R-$R_VERSION\bin\x64\R.exe"
$env:RSTUDIO_CONFIG_HOME = "C:\RStudio\user-data"
$env:RSTUDIO_DATA_HOME = "C:\RStudio\user-data"
[Environment]::SetEnvironmentVariable("RSTUDIO_WHICH_R", $env:RSTUDIO_WHICH_R, "User")
[Environment]::SetEnvironmentVariable("RSTUDIO_CONFIG_HOME", $env:RSTUDIO_CONFIG_HOME, "User")
[Environment]::SetEnvironmentVariable("RSTUDIO_DATA_HOME", $env:RSTUDIO_DATA_HOME, "User")
[Environment]::SetEnvironmentVariable("RSTUDIO_WHICH_R", $env:RSTUDIO_WHICH_R, "Machine")
[Environment]::SetEnvironmentVariable("RSTUDIO_CONFIG_HOME", $env:RSTUDIO_CONFIG_HOME, "Machine")
[Environment]::SetEnvironmentVariable("RSTUDIO_DATA_HOME", $env:RSTUDIO_DATA_HOME, "Machine")

# Create shortcut link on Desktop
$shortcut = $shell.CreateShortcut("$env:ALLUSERSPROFILE\Desktop\RStudio.lnk")
$shortcut.TargetPath = "C:\RStudio\rstudio.exe"
$shortcut.IconLocation = "C:\RStudio\rstudio.exe,0"
$shortcut.WorkingDirectory = "C:\RStudio"
$shortcut.Save()

# -------------------- Uninstall R and cleanup ---------------------------
Write-Output "Cleaning up..."
if (Test-Path -Path "$env:ProgramFiles\R\R-$R_VERSION\unins000.exe") {
    Start-Process -FilePath "$env:ProgramFiles\R\R-$R_VERSION\unins000.exe" -ArgumentList "/verysilent" -Wait
}
if (Test-Path -Path "$env:ProgramFiles\R\R-$R_VERSION") {
    Remove-Item -Path "$env:ProgramFiles\R\R-$R_VERSION" -Recurse -Force
}
if (Test-Path -Path "$env:APPDATA\Roaming\R") {
    Remove-Item -Path "$env:APPDATA\Roaming\R" -Recurse -Force
}
if (Test-Path -Path "C:\temp\r.exe") { Remove-Item -Path "C:\temp\r.exe" -Force }
if (Test-Path -Path "C:\temp\rstudio.zip") { Remove-Item -Path "C:\temp\rstudio.zip" -Force }
if (Test-Path -Path "C:\temp\rvscode.zip") { Remove-Item -Path "C:\temp\rvscode.zip" -Force }

# Pause for 15 seconds before exiting
Start-Sleep -Seconds 15
