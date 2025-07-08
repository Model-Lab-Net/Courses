@echo off
:: Title -- Code to install R, RStudio and R in VSCode
:: Author -- David Burg
:: For -- R course
:: Date -- 01/07/2025

::----------------------Get everything ready-------------------------------
set R_VERSION=4.5.1
set RSTUDIO_VERSION=2025.05.0-496
set VSCODE_VERSION=2901c5ac6db8a986a5666c3af51ff804d05af0d4/VSCode-win32-x64-1.101.2.zip
set RLANGSERVER_VERSION=0.3.16
set CURL_VERSION=8.14.1_2

c:
md c:\temp
cd c:\temp

if not exist c:\temp\curl.zip powershell Invoke-WebRequest -Uri 'https://curl.se/windows/dl-%CURL_VERSION%/curl-%CURL_VERSION%-win64-mingw.zip' -OutFile 'c:\temp\curl.zip'
if not exist c:\temp\curl.exe powershell Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\Temp" 
move /Y c:\temp\curl-%CURL_VERSION%-win64-mingw\bin\*.* c:\temp

if not exist 7.zip c:\temp\curl.exe --progress-bar -o 7.zip https://www.7-zip.org/a/7za920.zip
if not exist c:\temp\curl.exe powershell Expand-Archive -Path "C:\temp\7.zip" -DestinationPath "C:\Temp" 



::echo -------------------- Download R and RStudio installers ---------------------
:R_RStudio_Installers
::curl -o r.exe https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe  
::curl -o rstudio.exe https://download1.rstudio.org/electron/windows/RStudio-%RSTUDIO_VERSION%.exe  

::goto exit


echo --------------------------     Download R     ---------------------------
:Install_R
if not exist c:\temp\r.exe c:\temp\curl.exe --progress-bar -o  c:\temp\r.exe https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe
::powershell Invoke-WebRequest -Uri 'https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe' -OutFile 'c:\temp\r.exe'
if not exist "%programfiles%\R\R-%R_VERSION%\bin" start /wait c:\temp\r.exe /VERYSILENT /NORESTART /SP-
copy /Y "%programfiles%\R\R-%R_VERSION%\bin\x64\Rblas.dll"      "%programfiles%\R\R-%R_VERSION%\library\stats\libs\x64"
copy /Y "%programfiles%\R\R-%R_VERSION%\bin\x64\Rlapack.dll"    "%programfiles%\R\R-%R_VERSION%\library\stats\libs\x64"



echo ----------------- Download VSCode  ---  ZIP for portable ------------------
:IInstallVSCode
::if not exist c:\RVSCode md c:\RVSCode
::cd c:\RVSCode
if not exist c:\temp\rvscode.zip c:\temp\curl.exe --progress-bar -o rvscode.zip https://vscode.download.prss.microsoft.com/dbazure/download/stable/%VSCODE_VERSION%
::powershell Invoke-WebRequest -Uri 'https://vscode.download.prss.microsoft.com/dbazure/download/stable/%VSCODE_VERSION%' -OutFile 'c:\Temp\rvscode.zip'
if not exist c:\rvscode\code.exe powershell Expand-Archive -Path "C:\temp\rvscode.zip" -DestinationPath "C:\RVSCode" 


::Make folders for main course files
md c:\RVSCode\data\user-data\User\
md c:\RVSCode\R
md c:\RVSCode\Course\EpiCode
md c:\RVSCode\Course\EpiData

::copy R to VSCode main folder
robocopy "%programfiles%\R" "c:\RVSCode\R" /E /NFL /NDL /NJH /NJS /MT:4


::install R languaugeserver package
if not exist c:\Temp\languageserver.zip c:\temp\curl.exe --progress-bar -o c:\Temp\languageserver.zip https://cran.r-project.org/bin/windows/contrib/4.6/languageserver_%RLANGSERVER_VERSION%.zip
::powershell Invoke-WebRequest -Uri 'https://cran.r-project.org/bin/windows/contrib/4.6/languageserver_%RLANGSERVER_VERSION%.zip' -OutFile 'c:\Temp\languageserver.zip'
c:\RVSCode\R\R-%R_VERSION%\bin\R.exe CMD INSTALL c:\Temp\languageserver.zip


::set settings.json for R in VSCode
(
echo {
echo     "r.rpath.windows": "C:\\RVSCode\\R\\R-%R_VERSION%\\bin\\R.exe",
echo     "editor.dropIntoEditor.preferences": [],
echo     "r.rterm.option": [
echo         "--r-binary=C:\\RVSCode\\R\\R-%R_VERSION%\\bin\\R.exe",
echo         "--no-save",
echo         "--no-restore"
echo     ],
echo     "r.rterm.windows": "C:\\RVSCode\\R\\R-%R_VERSION%\\bin\\R.exe",
echo     "r.bracketedPaste": true,
echo     "r.sessionWatcher": true,
echo     "editor.wordSeparators": "`~!@#$%%^&*()=+[{]}\\|;:'^\",<>/?",
echo     "r.plot.useHttpgd": true,
echo     "terminal.integrated.profiles.windows": {
echo         "R": {
echo             "path": "C:\\RVSCode\\R\\R-%R_VERSION%\\bin\\R.exe",
echo             "args": [ "--no-save", "--no-restore" ],
echo             "env": {
echo                 "PATH": "C:\\RVSCode\\R\\R-%R_VERSION%\\bin"
echo             }
echo         }
echo     }
echo }
) > "C:\RVSCode\data\user-data\User\settings.json"


::Add extensions to VSCode
call C:\RVSCode\bin\code.cmd --install-extension github.copilot
call C:\RVSCode\bin\code.cmd --install-extension github.copilot-chat
call C:\RVSCode\bin\code.cmd --install-extension reditorsupport.r
call C:\RVSCode\bin\code.cmd --install-extension rdebugger.r-debugger

::Download first script to initialize for course
curl --progress-bar -o c:\RVSCode\Course\Initialize_R_for_Epi.Rmd https://github.com/Model-Lab-Net/Courses/blob/main/Epi/Initialize_R_for_Epi.Rmd
::powershell Invoke-WebRequest -Uri 'https://github.com/Model-Lab-Net/Courses/blob/main/Epi/Initialize_R_for_Epi.Rmd' -OutFile 'c:\RVSCode\Course\Initialize_R.Rmd'

::Create shortcut link to Desktop
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\RVSCode.lnk');$s.TargetPath='C:\RVSCode\code.exe';$s.Arguments='\"C:\RVScode\Course\"';$s.IconLocation='C:\RVSCode\code.exe,0';$s.Save()"



echo ---------------- Download RStudio  ---  ZIP for portable --------------------
:Install_Rstudio
::c:
::md c:\RStudio
::cd c:\RStudio
if not exist rstudio.zip c:\temp\curl.exe --progress-bar -o c:\temp\rstudio.zip https://download1.rstudio.org/electron/windows/RStudio-%RSTUDIO_VERSION%.zip
if not exist c:\rstudio\rstudio.exe powershell Expand-Archive -Path "C:\temp\rstudio.zip" -DestinationPath "C:\RStudio" 
::tar -xf rstudio.zip

:: download some settings for RStudio
c:\temp\curl.exe --progress-bar -o c:\RStudio\user-data\rstudio-prefs.json https://drive.usercontent.google.com/download?id=19KaP4pbdM_O78gcgepxqE196SG0zE7fq
c:\temp\curl.exe --progress-bar -o c:\RStudio\user-data\rstudio-desktop.json https://drive.usercontent.google.com/download?id=1priqCaKnSOOwCRU5J0anC8mH2gQMQYxE


md c:\RStudio\Course
md c:\RStudio\user-data

::Set env variables
SET RSTUDIO_WHICH_R=.\R\R-%R_VERSION%\bin\x64\R.exe
SET RSTUDIO_CONFIG_HOME=c:\RStudio\user-data 
SET RSTUDIO_DATA_HOME=c:\RStudio\user-data 
setx RSTUDIO_WHICH_R %RSTUDIO_WHICH_R%
setx RSTUDIO_CONFIG_HOME %RSTUDIO_CONFIG_HOME%
setx RSTUDIO_DATA_HOME %RSTUDIO_DATA_HOME%
setx /M RSTUDIO_WHICH_R %RSTUDIO_WHICH_R%
setx /M RSTUDIO_CONFIG_HOME %RSTUDIO_CONFIG_HOME%
setx /M RSTUDIO_DATA_HOME %RSTUDIO_DATA_HOME%


::Make folder for main course files
md c:\RStudio\R
md c:\RStudio\Course


::copy R to RStudio main folder
robocopy "%programfiles%\R" "c:\RStudio\R" /E /NFL /NDL /NJH /NJS /MT:4

::Create shortcut link on Desktop
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\RStudio.lnk');$s.TargetPath='C:\RStudio\rstudio.exe';$s.IconLocation='C:\RStudio\rstudio.exe,0';$s.WorkingDirectory='C:\RStudio';$s.Save()"



echo ------------------------Uninstall R and cleanup----------------------------------
:Cleanup  
"C:\Program Files\R\R-%R_VERSION%\unins000.exe" /verysilent
rd /s /q "C:\Program Files\R\R-%R_VERSION%"
rd /s /q "%AppData%\Roaming\R"
if exist c:\temp\r.exe del /F /S c:\temp\r.exe
if exist c:\temp\rstudio.zip del /F /S c:\temp\rstudio.zip
if exist c:\tempCode\rvscode.zip   del /F /S c:\temp\rvscode.zip



:exit
timeout /T 15
exit

