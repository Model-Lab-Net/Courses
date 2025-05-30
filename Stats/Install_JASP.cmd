@echo off
:: Title -- Code to install JASP
:: Author -- David Burg
:: For -- R course
:: Date -- 12/05/2025

::----------------------Get everything ready-------------------------------
set J_VERSION=0.19.3.0

c:
md c:\temp
cd c:\temp
if not exist curl.zip powershell Invoke-WebRequest -Uri 'https://curl.se/windows/dl-8.13.0_3/curl-8.13.0_3-win64-mingw.zip' -OutFile 'c:\temp\curl.zip'
powershell Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\Temp" 
move c:\temp\curl-8.13.0_3-win64-mingw\bin\*.* c:\temp



echo --------------------------     Download JASP  installer   ---------------------------
:Install_JASP
::if not exist jasp.exe powershell Invoke-WebRequest -Uri 'https://github.com/jasp-stats/jasp-desktop/releases/download/v%J_VERSION%/JASP-%J_VERSION%-Windows.msi' -OutFile 'c:\temp\jasp.msi'
::powershell Invoke-WebRequest -Uri 'https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe' -OutFile 'c:\temp\r.exe'
::jasp.msi /quiet
::powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\RStudio.lnk');$s.TargetPath='"C:\Program Files (x86)\JASP\JASP.exe"';$s.IconLocation='"C:\Program Files (x86)\JASP\JASP.exe",0';$s.WorkingDirectory='"C:\Program Files (x86)\JASP"';$s.Save()"
::goto exit


echo --------------------   Download JASP  ---  ZIP for portable   ---------------------
:IInstallVSCode
if not exist jasp.zip powershell Invoke-WebRequest -Uri 'https://github.com/jasp-stats/jasp-desktop/releases/download/v%J_VERSION%/JASP-%J_VERSION%-Windows.zip' -OutFile 'c:\temp\jasp.zip'
powershell Expand-Archive -Path "C:\temp\jasp.zip" -DestinationPath "C:\JASP" 

::Create shortcut link to Desktop
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\JASP.lnk');$s.TargetPath='C:\JASP\JASP.exe';$s.IconLocation='C:\JASP\JASP.exe,0';$s.Save()"


echo ---------------------   Uninstall R and cleanup   -------------------------------
:Cleanup
if exist c:\temp\jasp.zip   del /F /S c:\temp\jasp.zip
if exist c:\temp\jasp.msi   del /F /S c:\temp\jasp.msi
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\JASP" rd /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\JASP"


:exit
timeout /T 15
exit

