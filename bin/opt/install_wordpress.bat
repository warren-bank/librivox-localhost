@echo off

call "%~dp0..\env.bat"
call "%~dp0..\..\tools\env.bat"
set wget_opts=--no-hsts --no-check-certificate

if not exist "%dir_laragon%\www\librivox.org" (
  echo Please install Laragon server before WordPress
  echo.
  pause
  exit 1
)

if exist "%dir_laragon%\www\librivox.org\wordpress\wp-config.php" (
  echo WordPress is already installed
  echo.
  pause
  exit 0
)

cd /D "%dir_laragon%\www\librivox.org"

if exist "wordpress" rmdir /Q /S "wordpress"

rem :: https://wordpress.org/download/
rem :: https://wordpress.org/download/releases/
rem :: https://displaywp.com/wordpress-minimum-mysql-version/
wget %wget_opts% -O "wordpress.zip" "https://wordpress.org/wordpress-6.2.zip"
7z x "wordpress.zip"
rm "wordpress.zip"

copy "%~dp0..\..\conf\opt\wordpress.conf" "%cd%\wordpress\wp-config.php"

call "%~dp0.\update_wordpress_theme.bat" "1"

echo.
echo WordPress install is complete!
echo.
pause

cls
echo Open a web browser to:
echo   http://librivox.org.test/
echo.
pause
