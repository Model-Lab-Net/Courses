@echo off
:: Title -- Code to install Jamovi
:: Author -- David Burg
:: For -- R course
:: Date -- 12/05/2025

::---------------------- Get everything ready -------------------------------
set J_VERSION=2.6.44.0

c:
md c:\temp
cd c:\temp
if not exist curl.zip powershell Invoke-WebRequest -Uri 'https://curl.se/windows/dl-8.13.0_3/curl-8.13.0_3-win64-mingw.zip' -OutFile 'c:\temp\curl.zip'
powershell Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\Temp" 
move c:\temp\curl-8.13.0_3-win64-mingw\bin\*.* c:\temp



echo ------------------------ Download JAMOVI Installer ---------------------------
:R_RStudio_Installers
::curl -s -o c:\temp\jamovi.exe  https://dl.jamovi.org/jamovi-%J_VERSION%-win-x64.exe
c:\temp\jamovi.exe /S
::goto exit


echo -------------------- Download JAMOVI  ---  ZIP for portable ---------------------
:IInstallVSCode
::if not exist c:\VSCode md c:\VSCode
::md c:\JAMOVI
if not exist jamovi.zip curl.exe -o c:\temp\jamovi.exe jamovi.exe https://dl.jamovi.org/jamovi-%J_VERSION%-win-x64.zip 
powershell Expand-Archive -Path "C:\temp\jamovi.zip" -DestinationPath "C:\JAMOVI" 

::Create shortcut link on Desktop
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\Jamovi.lnk');$s.TargetPath='C:\Jamovi\Jamovi\bin\Jamovi.exe';$s.IconLocation='C:\Jamovi\Jamovi\bin\Jamovi.exe,0';$s.WorkingDirectory='C:\Jamovi\bin\Jamovi.exe';$s.Save()"


echo ------------------------ Cleanup ----------------------------------
:Cleanup
if exist c:\temp\jamovi.zip del /F /S c:\temp\jamovi.zip



:exit
timeout /T 15
exit

