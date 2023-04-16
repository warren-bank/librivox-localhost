@echo off

call "%~dp0.\env.bat"
call "%~dp0..\tools\env.bat"
set wget_opts=--no-hsts --no-check-certificate

if not exist "%dir_laragon%\www\librivox.org" (
  echo Error. Librivox server directory does not exist.
  echo.
  pause
  exit 1
)

cd /D "%dir_laragon%\www\librivox.org"

if exist "catalog" rmdir /Q /S "catalog"

wget %wget_opts% -O "catalog.zip" "https://github.com/LibriVox/librivox-catalog/archive/refs/heads/master.zip"
7z x "catalog.zip"
mv "librivox-catalog-master" "catalog"
rm "catalog.zip"

cd "%cd%\catalog\application\config\development"
wget %wget_opts% "https://github.com/LibriVox/librivox-ansible/raw/master/roles/blog+catalog/templates/config.php"
wget %wget_opts% "https://github.com/LibriVox/librivox-ansible/raw/master/roles/blog+catalog/templates/database.php"

mv "config.php" "config.php.bak"
perl -pe "$_ =~ s/\{\{ ci_log_threshold \}\}/4/; $_ =~ s/^(.*)(\{\{ [^\}]+ \}\})(.*)$/\/\/$1$2$3/;" <"config.php.bak" >"config.php"
rm "config.php.bak"

mv "database.php" "database.php.bak"
perl -pe "$_ =~ s/('username' => ')catalog(',)/$1root$2/; $_ =~ s/('password' => '){{ catalog_db_password }}(',)/$1$2/;" <"database.php.bak" >"database.php"
rm "database.php.bak"

echo.
echo Update of Librivox catalog PHP is complete!
echo.
pause
