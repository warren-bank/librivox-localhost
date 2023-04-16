@echo off

call "%~dp0..\tools\env.bat"

set output_file="%~dp0.\output\%~n0.json"

wget %wget_opts% -O %output_file% "http://librivox.org.test/api/feed/audiobooks/?author=twain&format=json&fields[]=id&fields[]=title&fields[]=authors&limit=5&offset=0&sort_field=id&sort_order=asc"
