@echo off

call "%~dp0..\env.bat"
call "%~dp0..\..\tools\env.bat"
set wget_opts=--no-hsts --no-check-certificate

if not exist "%dir_laragon%\etc\apps" (
  echo Please install Laragon server before PhpMyAdmin
  echo.
  pause
  exit 1
)

if exist "%dir_laragon%\etc\apps\phpmyadmin" (
  echo PhpMyAdmin is already installed
  echo.
  pause
  exit 0
)

cd /D "%dir_laragon%\etc\apps"

rem :: https://www.phpmyadmin.net/downloads/
wget %wget_opts% -O "phpmyadmin.zip" "https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-english.zip"
7z x "phpmyadmin.zip"
mv "phpMyAdmin-5.2.1-english" "phpmyadmin"
rm "phpmyadmin.zip"

copy "%~dp0..\..\conf\opt\phpmyadmin.conf" "%cd%\phpmyadmin\config.inc.php"

rem :: -------------------------------------------
rem :: https://stackoverflow.com/questions/38084464
rem :: https://stackoverflow.com/a/47956753
rem :: -------------------------------------------
rem :: Need to disable a few version checks in the code.
rem :: -------------------------------------------

set php_file=%cd%\phpmyadmin\libraries\classes\DatabaseInterface.php
mv "%php_file%" "%php_file%.bak"
perl -pe "if (($. >= 1106) && ($. <= 1109)) {$_ = '//' . $_;}" <"%php_file%.bak" >"%php_file%"
rm "%php_file%.bak"

set php_file=%cd%\phpmyadmin\libraries\classes\Common.php
mv "%php_file%" "%php_file%.bak"
perl -pe "if (($. >= 243) && ($. <= 251)) {$_ = '//' . $_;}" <"%php_file%.bak" >"%php_file%"
rm "%php_file%.bak"

echo.
echo PhpMyAdmin install is complete!
echo.
pause

cls
echo Open a web browser to:
echo   http://127.0.0.1/phpmyadmin/
echo.
pause
