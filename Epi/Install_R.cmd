@echo off
:: title -- Code to install R, RStudio and R in VSCode
:: author -- David Burg
:: for -- R course
:: date -- 12/05/2025

::----------------------Get everything ready-------------------------------
set R_VERSION=4.5.0
set RSTUDIO_VERSION=2024.12.1-563
set VSCODE_VERSION=17baf841131aa23349f217ca7c570c76ee87b957/VSCode-win32-x64-1.99.3

c:
md c:\temp
cd c:\temp
if not exist curl.zip powershell Invoke-WebRequest -Uri 'https://curl.se/windows/dl-8.13.0_3/curl-8.13.0_3-win64-mingw.zip' -OutFile 'c:\temp\curl.zip'
powershell Expand-Archive -Path "C:\temp\curl.zip" -DestinationPath "C:\Temp" 
move c:\temp\curl-8.13.0_3-win64-mingw\bin\*.* c:\temp



echo ------------------------Download R and RStudio installers---------------------------
:R_RStudio_Installers
::curl -o r.exe https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe  
::curl -o rstudio.exe https://download1.rstudio.org/electron/windows/RStudio-%RSTUDIO_VERSION%.exe  

::goto exit



echo --------------------------     Download R     ---------------------------
:Install_R
c:\temp\curl.exe -s -o c:\temp\r.exe https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe
::powershell Invoke-WebRequest -Uri 'https://cran.r-project.org/bin/windows/base/R-%R_VERSION%-win.exe' -OutFile 'c:\temp\r.exe'
start /wait r.exe /VERYSILENT /NORESTART /SP-
copy /Y "%programfiles%\R\R-%R_VERSION%\bin\x64\Rblas.dll"      "%programfiles%\R\R-%R_VERSION%\library\stats\libs\x64"
copy /Y "%programfiles%\R\R-%R_VERSION%\bin\x64\Rlapack.dll"    "%programfiles%\R\R-%R_VERSION%\library\stats\libs\x64"



echo --------------------Download VSCode  ---  ZIP for portable---------------------
:IInstallVSCode
::if not exist c:\VSCode md c:\VSCode
::cd c:\VSCode
if not exist vscode.zip c:\temp\curl.exe -s -o vscode.zip https://vscode.download.prss.microsoft.com/dbazure/download/stable/%VSCODE_VERSION%.zip
powershell Expand-Archive -Path "C:\temp\vscode.zip" -DestinationPath "C:\VSCode" 


md c:\VSCode\data\user-data\User\
md c:\VSCode\R

::Make folders for main course files
md c:\VSCode\data\Course\Code
md c:\VSCode\data\Course\Data

::copy R to VSCode main folder
robocopy "%programfiles%\R" "c:\VSCode\R" /S

::install R languaugeserver package
c:\temp\curl.exe -s -o c:\Temp\languageserver.zip https://cran.r-project.org/bin/windows/contrib/4.6/languageserver_0.3.16.zip
::powershell Invoke-WebRequest -Uri 'https://cran.r-project.org/bin/windows/contrib/4.6/languageserver_0.3.16.zip' -OutFile 'c:\Temp\languageserver.zip'
c:\VSCode\R\R-%R_VERSION%\bin\R.exe CMD INSTALL c:\Temp\languageserver.zip

::Set settings.json for R in VSCode
(
echo {
echo     "r.rpath.windows": "C:\\VSCode\\R\\R-%R_VERSION%\\bin\\R.exe",
echo     "editor.dropIntoEditor.preferences": [],
echo     "r.rterm.option": [
echo         "--r-binary=C:\\VSCode\\R\\R-%R_VERSION%\\bin\\R.exe", 
echo         "--no-save", 
echo         "--no-restore"
echo     ],
echo     "r.rterm.windows": "C:\\VSCode\\R\\R-%R_VERSION%\\bin\\R.exe",
echo     "r.bracketedPaste": true,
echo     "r.plot.useHttpgd": true,
echo     "terminal.integrated.profiles.windows": {
echo         "R": {
echo             "path": "C:\\VSCode\\R\\R-%R_VERSION%\\bin\\R.exe",
echo             "args": [ "--no-save", "--no-restore" ],
echo             "env": {
echo                 "PATH": "C:\\VSCode\\R\\R-%R_VERSION%\\bin"
echo             }
echo         }
echo     }
echo }
) > c:\VSCode\data\user-data\User\settings.json


::Add extensions to VSCode
::code.exe --install-extension github.copilot
::code.exe --install-extension github.copilot-chat
::code.exe --install-extension reditorsupport.r
::code.exe --install-extension rdebugger.r-debugger


::Create shortcut link to Desktop
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%ALLUSERSPROFILE%\Desktop\RVSCode.lnk');$s.TargetPath='C:\VSCode\code.exe';$s.IconLocation='C:\VSCode\code.exe,0';$s.Save()"

::Download first script to initialize for course
::powershell Invoke-WebRequest -Uri 'https://___.rmd' -OutFile 'c:\VSCode\data\Course\Code'


echo -----------------------Download RStudio  ---  ZIP for portable-----------------------------------
:Install_Rstudio
::c:
::md c:\RStudio
::cd c:\RStudio
if not exist rstudio.zip c:\temp\curl.exe -s -o rstudio.zip https://download1.rstudio.org/electron/windows/RStudio-%RSTUDIO_VERSION%.zip
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
md c:\RStudio\course


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
if exist c:\tempCode\VSCode.zip   del /F /S c:\temp\VSCode.zip


:exit
timeout /T 15
exit

