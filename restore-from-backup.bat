@echo off

if exist %HOMEDRIVE%%HOMEPATH%\.npmrc (
  copy backup\npm.txt %HOMEDRIVE%%HOMEPATH%\.npmrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.bowerrc (
  copy backup\bower.txt %HOMEDRIVE%%HOMEPATH%\.bowerrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.curlrc (
  copy backup\curl.txt %HOMEDRIVE%%HOMEPATH%\.curlrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.wgetrc (
  copy backup\wget.txt %HOMEDRIVE%%HOMEPATH%\.wgetrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.gitconfig (
  copy backup\git.txt %HOMEDRIVE%%HOMEPATH%\.gitconfig /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.ssh\config (
  copy backup\ssh.txt %HOMEDRIVE%%HOMEPATH%\.ssh\config /y
)

if exist c:\ruby193\bin\gem.bat (
  copy backup\ruby.txt c:\ruby193\bin\gem.bat /y
)

echo Backup configuration files restored!

echo.
echo Press any key to exit...
@pause >nul
@exit
