@echo off

call "%~dp0.\env.bat"
call "%~dp0..\tools\env.bat"

cd /D "%dir_laragon%\www\librivox.org"

set cfg_file=%dir_laragon%\etc\nginx\sites-enabled\librivox.org.test.conf
mv "%cfg_file%" "%cfg_file%.bak"
perl -pe "s/(root ')[^']*(';)/$1%cd:\=\\%$2/" <"%cfg_file%.bak" >"%cfg_file%"
rm "%cfg_file%.bak"

rem :: start Laragon (nginx, mysql)
start "Laragon" "%dir_laragon%\laragon.exe"
