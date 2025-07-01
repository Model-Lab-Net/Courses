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
if not exist curl.zip powershell Invoke-WebRequest -Uri 'https://curl.se/windows/dl-%CURL_VERSION%/curl-%CURL_VERSION%-win64-mingw.zip' -OutFile 'c:\temp\curl.zip'
powershell Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\Temp" 
move c:\temp\curl-%CURL_VERSION%-win64-mingw\bin\*.* c:\temp



echo -------------------- Download R and RStudio installers ---------------------
:R_RStudio_Installers
::curl -o r.exe https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe  
::curl -o rstudio.exe https://download1.rstudio.org/electron/windows/RStudio-%RSTUDIO_VERSION%.exe  

::goto exit


echo --------------------------     Download R     ---------------------------
:Install_R
c:\temp\curl.exe --progress-bar -o  c:\temp\r.exe https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe
::powershell Invoke-WebRequest -Uri 'https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe' -OutFile 'c:\temp\r.exe'
start /wait r.exe /VERYSILENT /NORESTART /SP-
copy /Y "%programfiles%\R\R-%R_VERSION%\bin\x64\Rblas.dll"      "%programfiles%\R\R-%R_VERSION%\library\stats\libs\x64"
copy /Y "%programfiles%\R\R-%R_VERSION%\bin\x64\Rlapack.dll"    "%programfiles%\R\R-%R_VERSION%\library\stats\libs\x64"



echo ----------------- Download VSCode  ---  ZIP for portable ------------------
:IInstallVSCode
::if not exist c:\RVSCode md c:\RVSCode
::cd c:\RVSCode
::if not exist rvscode.zip c:\temp\curl.exe --progress-bar -o rvscode.zip https://vscode.download.prss.microsoft.com/dbazure/download/stable/%VSCODE_VERSION%.zip
powershell Invoke-WebRequest -Uri 'https://vscode.download.prss.microsoft.com/dbazure/download/stable/%VSCODE_VERSION%' -OutFile 'c:\Temp\rvscode.zip'
powershell Expand-Archive -Path "C:\temp\rvscode.zip" -DestinationPath "C:\RVSCode" 


::Make folders for main course files
md c:\RVSCode\data\user-data\User\
md c:\RVSCode\R
md c:\RVSCode\data\Course\EpiCode
md c:\RVSCode\data\Course\EpiData

::copy R to VSCode main folder
robocopy "%programfiles%\R" "c:\RVSCode\R" /S

::install R languaugeserver package
c:\temp\curl.exe --progress-bar -o c:\Temp\languageserver.zip https://cran.r-project.org/bin/windows/contrib/4.6/languageserver_%RLANGSERVER_VERSION%.zip
::powershell Invoke-WebRequest -Uri 'https://cran.r-project.org/bin/windows/contrib/4.6/languageserver_%RLANGSERVER_VERSION%.zip' -OutFile 'c:\Temp\languageserver.zip'
c:\RVSCode\R\R-%R_VERSION%\bin\R.exe CMD INSTALL c:\Temp\languageserver.zip

::Set settings.json for R in VSCode
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
) > c:\RVSCode\data\user-data\User\settings.json


::Add extensions to VSCode
call C:\RVSCode\bin\code.cmd --install-extension github.copilot
call C:\RVSCode\bin\code.cmd --install-extension github.copilot-chat
call C:\RVSCode\bin\code.cmd --install-extension reditorsupport.r
call C:\RVSCode\bin\code.cmd --install-extension rdebugger.r-debugger

::Download first script to initialize for course
curl -o c:\RVSCode\Course\Initialize_R_for_Epi.Rmd https://github.com/Model-Lab-Net/Courses/blob/main/Epi/Initialize_R_for_Epi.Rmd
::powershell Invoke-WebRequest -Uri 'https://github.com/Model-Lab-Net/Courses/blob/main/Epi/Initialize_R_for_Epi.Rmd' -OutFile 'c:\RVSCode\Course\Initialize_R.Rmd'

::Create shortcut link to Desktop
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\RVSCode.lnk');$s.TargetPath='C:\RVSCode\code.exe';$s.IconLocation='C:\RVSCode\code.exe,0';$s.Save()"


echo ---------------- Download RStudio  ---  ZIP for portable --------------------
:Install_Rstudio
::c:
::md c:\RStudio
::cd c:\RStudio
if not exist rstudio.zip c:\temp\curl.exe --progress-bar -o rstudio.zip https://download1.rstudio.org/electron/windows/RStudio-%RSTUDIO_VERSION%.zip
powershell Expand-Archive -Path "C:\temp\rstudio.zip" -DestinationPath "C:\Rstudio" 
::tar -xf rstudio.zip


::Set env variables
SET RSTUDIO_WHICH_R=.\R\R-%R_VERSION%\bin\x64\R.exe
SET RSTUDIO_CONFIG_HOME=.\ 
SET RSTUDIO_DATA_HOME=.\ 
setx RSTUDIO_WHICH_R %RSTUDIO_WHICH_R
setx RSTUDIO_CONFIG_HOME %RSTUDIO_CONFIG_HOME%
setx RSTUDIO_DATA_HOME %RSTUDIO_DATA_HOME%
setx /M RSTUDIO_WHICH_R %RSTUDIO_WHICH_R
setx /M RSTUDIO_CONFIG_HOME %RSTUDIO_CONFIG_HOME%
setx /M RSTUDIO_DATA_HOME %RSTUDIO_DATA_HOME%

  
::Create two JSON files
(
echo {
echo     "windows_terminal_shell": "win-cmd",
echo     "font_size_points": 12,
echo     "jobs_tab_visibility": "shown",
echo     "highlight_r_function_calls": true,
echo     "show_rmd_render_command": true,
echo     "graphics_backend": "ragg",
echo     "graphics_antialiasing": "subpixel",
echo     "use_tinytex": true,
echo     "auto_append_newline": true,
echo     "source_with_echo": true,
echo     "pdf_previewer": "none",
echo     "full_project_path_in_window_title": true,
echo     "show_last_dot_value": true,
echo     "rainbow_parentheses": true,
echo     "check_arguments_to_r_function_calls": true,
echo     "warn_variable_defined_but_not_used": true,
echo     "syntax_color_console": true,
echo     "show_doc_outline_rmd": true,
echo     "rmd_auto_date": true,
echo     "soft_wrap_rmd_files": false,
echo     "show_terminal_tab": false,
echo     "handle_errors_in_user_code_only": false,
echo     "restore_source_documents": false,
echo     "restore_last_project": false,
echo     "always_save_history": false,
echo     "default_open_project_location": "./course",
echo     "default_project_location": "./course",
echo     "initial_working_directory": "./course"
echo }
) > c:\RStudio\rstudio-prefs.json


(
echo {
echo     "context_id": "35AE8513",
echo     "theme": {
echo         "name": "Material",,
echo         "url": "theme/default/material.rstheme",
echo         "isDark": true
echo }
) > c:\RStudio\rstudio-desktop.json


::Make folder for main course files
md c:\RStudio\R
md c:\RStudio\Course


::copy R to RStudio main folder
robocopy "%programfiles%\R" "c:\RStudio\R" /S

::Create shortcut link on Desktop
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\RStudio.lnk');$s.TargetPath='C:\RStudio\rstudio.exe';$s.IconLocation='C:\RStudio\rstudio.exe,0';$s.WorkingDirectory='C:\RStudio';$s.Save()"



echo ------------------------Uninstall R and cleanup----------------------------------
:Cleanup  
"C:\Program Files\R\R-%R_VERSION%\unins000.exe" /verysilent
rd /s /q "C:\Program Files\R\R-%R_VERSION%"
if exist c:\temp\r.exe del /F /S c:\temp\r.exe
if exist c:\temp\rstudio.zip del /F /S c:\temp\rstudio.zip
if exist c:\tempCode\rvscode.zip   del /F /S c:\temp\rvscode.zip


:exit
timeout /T 15
exit

