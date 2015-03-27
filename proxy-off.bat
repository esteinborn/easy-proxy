if exist %HOMEDRIVE%%HOMEPATH%\.npmrc (
  copy configs\npm.proxy-off.txt %HOMEDRIVE%%HOMEPATH%\.npmrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.bowerrc (
  copy configs\bower.proxy-off.txt %HOMEDRIVE%%HOMEPATH%\.bowerrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.curlrc (
  copy configs\curl.proxy-off.txt %HOMEDRIVE%%HOMEPATH%\.curlrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.wgetrc (
  copy configs\wget.proxy-off.txt %HOMEDRIVE%%HOMEPATH%\.wgetrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.gitconfig (
  copy configs\git.proxy-off.txt %HOMEDRIVE%%HOMEPATH%\.gitconfig /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.ssh\config (
  copy configs\ssh.proxy-off.txt %HOMEDRIVE%%HOMEPATH%\.ssh\config /y
)

if exist c:\ruby193\bin\gem.bat (
  copy configs\ruby.proxy-off.txt c:\ruby193\bin\gem.bat /y
)
