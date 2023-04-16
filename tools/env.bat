@echo off

if defined dir_laragon (
  set mysql_bin=%dir_laragon%\bin\mysql\mysql-5.1.72-win32\bin
  set PATH=%mysql_bin%;%PATH%
)

set zip7_bin=%~dp0.\7-Zip\16.02
set PATH=%zip7_bin%;%PATH%

set perl_bin=%~dp0.\perl\5.10.1
set PATH=%perl_bin%;%PATH%

set wget_bin=%~dp0.\wget\1.19.4
set PATH=%wget_bin%;%PATH%
