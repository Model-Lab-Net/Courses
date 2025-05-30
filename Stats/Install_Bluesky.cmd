@echo off
:: Title -- Code to install Bluesky Statistics
:: Author -- David Burg
:: For -- R course
:: Date -- 12/05/2025

::----------------------Get everything ready-------------------------------
set BS_VERSION=10.3.4
set ARIA_VERSION=1.37.0

c:
md c:\temp
cd c:\temp
if not exist curl.zip powershell Invoke-WebRequest -Uri 'https://curl.se/windows/dl-8.13.0_3/curl-8.13.0_3-win64-mingw.zip' -OutFile 'c:\temp\curl.zip'
powershell Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\Temp" 
move c:\temp\curl-8.13.0_3-win64-mingw\bin\*.* c:\temp
if not exist aria.zip powershell Invoke-WebRequest -Uri 'https://github.com/aria2/aria2/releases/download/release-%ARIA_VERSION%/aria2-%ARIA_VERSION%-win-64bit-build1.zip' -OutFile 'c:\temp\aria.zip'
powershell Expand-Archive -Path "C:\temp\aria.zip" -DestinationPath "C:\temp" 
move C:\Temp\aria2-%ARIA_VERSION%-win-64bit-build1\aria2c.exe c:\temp\aria2.exe


echo --------------------------     Download Bluesky  installer   ---------------------------
:Install_Bluesky
::if not exist bluesky.exe aria2 -o bluesky.exe https://www.blueskystat.net/v%BS_VERSION%WinOpn/BlueSky%20Statistics-v%BS_VERSION%.exe
if not exist bluesky.exe curl -o bluesky.exe https://www.blueskystat.net/v%BS_VERSION%WinOpn/BlueSky%20Statistics-v%BS_VERSION%.exe
::if not exist bluesky.exe powershell Invoke-WebRequest -Uri 'https://www.blueskystat.net/v%BS_VERSION%WinOpn/BlueSky%20Statistics-v%BS_VERSION%.exe' -OutFile 'c:\temp\bluesky.exe'
bluesky.exe /S

::goto exit


echo ------------------------   Uninstall R and cleanup   --------------------------------
:Cleanup
if exist c:\temp\bluesky.exe del /F /S c:\temp\bluesky.exe


:exit
timeout /T 15
exit

