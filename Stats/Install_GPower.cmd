@echo off
:: Title -- Code to install R, RStudio and R in VSCode
:: Author -- David Burg
:: For -- R course
:: Date -- 12/05/2025

::----------------------Get everything ready-------------------------------
set R_VERSION=4.5.0
set RSTUDIO_VERSION=2025.05.0-496
set VSCODE_VERSION=848b80aeb52026648a8ff9f7c45a9b0a80641e2e/VSCode-win32-arm64-1.100.2
set RLANGSERVER_VERSION=0.3.16
set CURL_VERSION=8.14.1_2
set GPOWER_VERSION=3.1.9.7
set GPOWER_subVERSION=143

c:
md c:\temp
cd c:\temp
if not exist curl.zip powershell Invoke-WebRequest -Uri 'https://curl.se/windows/dl-%CURL_VERSION%/curl-%CURL_VERSION%-win64-mingw.zip' -OutFile 'c:\temp\curl.zip'
powershell Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\Temp" 
move c:\temp\curl-%CURL_VERSION%-win64-mingw\bin\*.* c:\temp




echo ----------------- Download VSCode  ---  ZIP for portable ------------------
:InstallGPower
if not exist gpower.zip c:\temp\curl.exe -s -o gpower.zip https://www.psychologie.hhu.de/fileadmin/redaktion/Fakultaeten/Mathematisch-Naturwissenschaftliche_Fakultaet/Psychologie/AAP/gpower/GPowerWin_%GPOWER_VERSION%.zip
powershell Expand-Archive -Path "C:\temp\gpower.zip" -DestinationPath "C:\temp" 

md c:\GPower
copy C:\temp\GPower_%GPOWER_VERSION%_%GPOWER_subVERSION% c:\GPower

::Create shortcut link on Desktop
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\GPower.lnk');$s.TargetPath='C:\GPower\GPowerNT.exe';$s.IconLocation='C:\GPower\GPowerNT.exe,0';$s.WorkingDirectory='C:\GPower';$s.Save()"

::Download docs
if not exist "GPower Manual.pdf" c:\temp\curl.exe -s -o "GPower Manual.pdf" https://www.psychologie.hhu.de/fileadmin/redaktion/Fakultaeten/Mathematisch-Naturwissenschaftliche_Fakultaet/Psychologie/AAP/gpower/GPowerManual.pdf
if not exist "GPower GetStarted.pdf" c:\temp\curl.exe -s -o "GPower GetStarted.pdf" https://www.psychologie.hhu.de/fileadmin/redaktion/Fakultaeten/Mathematisch-Naturwissenschaftliche_Fakultaet/Psychologie/AAP/gpower/GPowerShortTutorial.pdf

move /Y C:\temp\*.pdf c:\GPower


echo ------------------------Uninstall R and cleanup----------------------------------
:Cleanup  
rd /S /Q C:\temp\GPower_%GPOWER_VERSION%_%GPOWER_subVERSION%
del /F /Q C:\temp\GPower*.*


:exit
timeout /T 15
exit

