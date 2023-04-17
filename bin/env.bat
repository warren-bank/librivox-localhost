@echo off

if defined dir_laragon goto :done

set tag_laragon=6.0.0

set dir_base=%~dp0..\dist\PortableApps
set dir_laragon=%dir_base%\Laragon\%tag_laragon%

:done
