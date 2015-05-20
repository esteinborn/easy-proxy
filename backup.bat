@echo off

if not exist backup mkdir backup

:: Begin backup of existing files
if exist %HOMEDRIVE%%HOMEPATH%\.npmrc (
  copy %HOMEDRIVE%%HOMEPATH%\.npmrc backup\npm.txt /y>NUL
)

if exist %HOMEDRIVE%%HOMEPATH%\.bowerrc (
  copy %HOMEDRIVE%%HOMEPATH%\.bowerrc backup\bower.txt /y>NUL
)

if exist %HOMEDRIVE%%HOMEPATH%\.curlrc (
  copy %HOMEDRIVE%%HOMEPATH%\.curlrc backup\curl.txt /y>NUL
)

if exist %HOMEDRIVE%%HOMEPATH%\.wgetrc (
  copy %HOMEDRIVE%%HOMEPATH%\.wgetrc backup\wget.txt /y>NUL
)

if exist %HOMEDRIVE%%HOMEPATH%\.gitconfig (
  copy %HOMEDRIVE%%HOMEPATH%\.gitconfig backup\git.txt /y>NUL
)

if exist %HOMEDRIVE%%HOMEPATH%\.ssh\config (
  copy %HOMEDRIVE%%HOMEPATH%\.ssh\config backup\ssh.txt /y>NUL
)

if exist c:\ruby193\bin\gem.bat (
  copy c:\ruby193\bin\gem.bat backup\ruby.txt /y>NUL
)
endlocal
