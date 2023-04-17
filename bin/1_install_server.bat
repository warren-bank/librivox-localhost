@echo off

rem :: -------------------------------------------
rem :: runtime environment:
rem ::   Laragon 6.0.0
rem ::     php-8.1.9-nts-Win32-vs16-x64 (updated from: php-5.4.9-nts-Win32-VC9-x86)
rem ::     mysql-5.1.72-win32
rem ::     nginx-1.14.0
rem :: -------------------------------------------
rem :: runtime environment download links:
rem :: - Laragon:
rem ::   https://laragon.org/download/index.html
rem ::   https://github.com/leokhoa/laragon/releases/tag/6.0.0
rem ::   https://github.com/leokhoa/laragon/archive/refs/tags/6.0.0.zip
rem :: - PHP:
rem ::   https://windows.php.net/downloads/releases/archives/
rem ::   https://windows.php.net/downloads/releases/archives/php-8.1.9-nts-Win32-vs16-x64.zip
rem :: -------------------------------------------

call "%~dp0.\env.bat"
call "%~dp0..\tools\env.bat"
set wget_opts=--no-hsts --no-check-certificate

:install_laragon

if exist "%dir_laragon%" goto :install_librivox

mkdir "%dir_laragon%"
cd /D "%dir_laragon%\.."

wget %wget_opts% -O "laragon.zip" "https://github.com/leokhoa/laragon/archive/refs/tags/%tag_laragon%.zip"
7z x "laragon.zip"
rmdir /Q /S "%tag_laragon%"
mv "laragon-%tag_laragon%" "%tag_laragon%"
rm "laragon.zip"

cd "%dir_laragon%\bin\php"
rmdir /Q /S "php-5.4.9-nts-Win32-VC9-x86"

mkdir "php-8.1.9-nts-Win32-vs16-x64"
wget %wget_opts% -O "php.zip" "https://windows.php.net/downloads/releases/archives/php-8.1.9-nts-Win32-vs16-x64.zip"
7z x "php.zip" -o"php-8.1.9-nts-Win32-vs16-x64"
rm "php.zip"

set cfg_file=%dir_laragon%\usr\laragon.ini
mv "%cfg_file%" "%cfg_file%.bak"
perl -pe "s/^Version=php-5.4.9-nts-Win32-VC9-x86$/Version=php-8.1.9-nts-Win32-vs16-x64/" <"%cfg_file%.bak" >"%cfg_file%"
rm "%cfg_file%.bak"

set cfg_file=%dir_laragon%\bin\nginx\nginx-1.14.0\conf\snippets\fastcgi-php.conf
mv "%cfg_file%" "%cfg_file%.bak"
perl -pe "s/^(try_files .+)$/# $1/" <"%cfg_file%.bak" >"%cfg_file%"
rm "%cfg_file%.bak"

rem :: migrate some Apache mod-rewrite rules from
rem ::   https://github.com/LibriVox/librivox-ansible/blob/master/roles/blog%2Bcatalog/templates/librivox.org.conf
mkdir "%dir_laragon%\etc\nginx\sites-enabled"
perl -pe "s/\{\{ root_directory_path \}\}/%cd:\=\\%/" <"%~dp0..\conf\nginx.conf" >"%dir_laragon%\etc\nginx\sites-enabled\librivox.org.test.conf"

:install_librivox

if exist "%dir_laragon%\www\librivox.org" (
  echo Laragon server and Librivox catalog are already installed
  echo.
  pause
  exit 0
)

mkdir "%dir_laragon%\www\librivox.org"
cd /D "%dir_laragon%\www\librivox.org"

wget %wget_opts% -O "catalog.zip" "https://github.com/warren-bank/fork-librivox-catalog/archive/refs/heads/PR/api/sort_field.zip"
7z x "catalog.zip"
mv "fork-librivox-catalog-PR-api-sort_field" "catalog"
rm "catalog.zip"

copy "%~dp0..\conf\catalog.config.conf"   "%cd%\catalog\application\config\config.php"
copy "%~dp0..\conf\catalog.database.conf" "%cd%\catalog\application\config\database.php"

wget %wget_opts% -O "catalog.sql.bz2" "https://github.com/LibriVox/librivox-ansible/raw/master/resources/librivox_catalog_scrubbed.sql.bz2"
7z x "catalog.sql.bz2"
rm "catalog.sql.bz2"

rem :: if using a version of MySQL older than 5.5.3
rem ::   https://dev.mysql.com/doc/refman/5.5/en/charset-unicode-utf8mb3.html
rem ::   https://dev.mysql.com/doc/refman/5.5/en/charset-unicode-utf8mb4.html
perl -pe "s/(utf8)mb[3-4]/$1/g" <"catalog.sql" >"catalog.utf8.sql"

rem :: start Laragon (nginx, mysql)
start "Laragon" "%dir_laragon%\laragon.exe"

rem :: note: user is required to press the "Start All" button in the GUI
rem :: see:  https://github.com/leokhoa/laragon/issues/154
echo.
echo Please press the "Start All" button in the Laragon GUI.
echo.
echo Upon doing so,
echo you must also grant permission to each server,
echo to allow it to listen on its assigned port.
echo.
pause

mysql -h "127.0.0.1" -u root -e "SHOW DATABASES;"
mysql -h "127.0.0.1" -u root -e "DROP DATABASE IF EXISTS librivox_catalog; CREATE DATABASE librivox_catalog;"
mysql -h "127.0.0.1" -u root -e "DROP DATABASE IF EXISTS librivox_forum;   CREATE DATABASE librivox_forum;"
mysql -h "127.0.0.1" -u root -e "DROP DATABASE IF EXISTS librivox_blog;    CREATE DATABASE librivox_blog;"
mysql -h "127.0.0.1" -u root -e "SHOW DATABASES;"

echo.
echo Please wait while the Librivox catalog database is populated...
mysql -h "127.0.0.1" -u root -D "librivox_catalog" <"catalog.utf8.sql"
rm "catalog.sql"
rm "catalog.utf8.sql"

echo.
echo Install is complete!
echo.
pause

cls
echo Open a web browser to:
echo   http://librivox.org.test/api/info
echo.
pause
