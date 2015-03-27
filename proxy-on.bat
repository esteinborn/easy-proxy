if exist %HOMEDRIVE%%HOMEPATH%\.npmrc (
  copy configs\npm.proxy-on.txt %HOMEDRIVE%%HOMEPATH%\.npmrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.bowerrc (
  copy configs\bower.proxy-on.txt %HOMEDRIVE%%HOMEPATH%\.bowerrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.curlrc (
  copy configs\curl.proxy-on.txt %HOMEDRIVE%%HOMEPATH%\.curlrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.wgetrc (
  copy configs\wget.proxy-on.txt %HOMEDRIVE%%HOMEPATH%\.wgetrc /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.gitconfig (
  copy configs\git.proxy-on.txt %HOMEDRIVE%%HOMEPATH%\.gitconfig /y
)

if exist %HOMEDRIVE%%HOMEPATH%\.ssh\config (
  copy configs\ssh.proxy-on.txt %HOMEDRIVE%%HOMEPATH%\.ssh\config /y
)

if exist c:\ruby193\bin\gem.bat (
  copy configs\ruby.proxy-on.txt c:\ruby193\bin\gem.bat /y
)
