@echo off

set silent_mode=%~1

call "%~dp0..\env.bat"
call "%~dp0..\..\tools\env.bat"
set wget_opts=--no-hsts --no-check-certificate

if not exist "%dir_laragon%\www\librivox.org\wordpress\wp-config.php" (
  echo Error. WordPress is not installed.
  echo.
  pause
  exit 1
)

cd /D "%dir_laragon%\www\librivox.org\wordpress"

if not exist "%cd%/wp-content/themes" mkdir "%cd%/wp-content/themes"
cd "%cd%/wp-content/themes"

if exist "librivox" rmdir /Q /S "librivox"

wget %wget_opts% -O "librivox.zip" "https://github.com/LibriVox/librivox-wordpress-theme/archive/refs/heads/master.zip"
7z x "librivox.zip"
mv "librivox-wordpress-theme-master" "librivox"
rm "librivox.zip"

if not "%silent_mode%"=="1" (
  echo.
  echo Update of Librivox WordPress theme is complete!
  echo.
  pause
)
