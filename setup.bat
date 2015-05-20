@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo.
echo ******************************************************************
echo ** Welcome to the Easy Proxy Configurator                       **
echo **                                                              **
echo ** This script installs a collection of proxy configuration     **
echo ** files for 7 different programs:                              **
echo ** NPM, Git, SSH, Bower, CURL, WGET, and Ruby (1.93)            **
echo **                                                              **
echo ** Follow the prompts below                                     **
echo ** Press ENTER to accept the [default] for each prompt          **
echo ******************************************************************
echo.
echo.

echo Enough chit chat, let's get started:
echo.


:: For users who have their homepath and home drive set to something else via group policy, we are going to set it to the actual locations of the config files as they were installed.
set CurrentHomepath=%HOMEPATH%
set ProxyPassword=""
set Password1=""
set Password2=""
set BackupError=""
set ToggleError=""

:: Remove and re-create errorlogs folder to log any errors to
:: We remove it at the bottom if its empty after running our script
if exist errorlogs rmdir "errorlogs" /S /Q
if not exist errorlogs mkdir errorlogs

set /p RunBackup= First, let's back up your existing configuration okay? [Y]: || set RunBackup=Y

if /i %RunBackup% == Y (
  call backup.bat 2>errorlogs\backup-log.txt
  goto backuperrorcheck
) else (
  goto proxysettings
)

:backuperrorcheck
if exist errorlogs\backup-log.txt (
  set /p BackupError=<errorlogs\backup-log.txt
) else (
  set BackupError = ""
)
if NOT "%BackupError%" == """" (
  echo.
  echo Backup may have failed. Check "backup" folder.
  goto cleanup
) else (
  echo.
  echo Existing configuration has been backed up successfully.
  echo Restore your backup files by running "restore-from-backup.bat"
  del errorlogs\backup-log.txt
)

::Prompt user for Proxy Settings
:proxysettings
echo.
set /p ProxyURL= What is your Proxy URL ^(NO port, HTTP optional^)? [http://yourproxy.com]: || set ProxyURL=yourproxy.com
echo.
set /p ProxyPort= What is your Proxy Port? [80]: || set ProxyPort=80
echo.
set /p HasProxyAuth= Does your proxy require a username and password in the connection string? [N]: || set HasProxyAuth=N

if /i %HasProxyAuth% == Y (
  goto setupauth
) else (
  goto setupapps
)


:setupauth
echo.
echo *************************************************************************
echo ** SPECIAL NOTE:                                                       **
echo ** Some proxies require that you use a domain\username to authenticate **
echo *************************************************************************
echo.

set /p HasProxyDomain= Does your proxy require you specify a domain in the connection string?? [Y] || set HasProxyDomain=Y
if /i %HasProxyDomain% == Y (
  goto getproxydomain
) else (
  goto getproxyusername
)


:getproxydomain
echo.
set /p ProxyDomain= What is your domain ^(No slashes^)? []: || set ProxyDomain=""

::We have to add the backslashes to the domain to work in config files
if not %ProxyDomain% == "" (
  set ProxyDomain=%ProxyDomain%\\
) else (
  echo You didnt enter a domain. Please enter a domain.
  goto getproxydomain
)


:getproxyusername
echo.
set /p ProxyUser= What is your proxy username?  []: || set ProxyUser=""
echo.

if not %ProxyUser% == "" (
  set ProxyUser=%ProxyUser%:
) else (
  echo You didnt enter a username. Please enter a username.
  goto getproxyusername
)

:getproxypassword
set "psCommand=powershell -Command "$pword = read-host 'Type your proxy password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set Password1=%%p

if %Password1% == "" (
  echo.
  echo You didnt enter a password, please enter a password.
  echo.
  goto getproxypassword
)

set "psCommand=powershell -Command "$pword = read-host 'Verify your proxy password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set Password2=%%p

if %Password1% == %Password2% (
  echo.
  echo Passwords Match^^!
  set ProxyPassword=%Password1%@
) else (
  echo.
  echo Passwords do not match. Please try again.
  echo.
  goto getproxypassword
)


:setupapps
:: Prompt user to configure each of the supported applications
echo.
echo.
echo ******************************************************************
echo ** Application Configuration                                    **
echo **                                                              **
echo ** ALL = (NPM, Git, SSH, Bower, CURL, WGET, and Ruby 1.93)      **
echo ******************************************************************
echo.
set /p AllConfig= Configure ALL available applications? [Y]: || set AllConfig=Y
echo.

if /i %AllConfig% == Y (
  set HasNPM=Y
  set HasWGET=Y
  set HasCURL=Y
  set HasRuby=Y
  set HasBower=Y
  set HasSSH=Y
  set HasGit=Y
  goto extraconfigs
) else (
  goto individualsetup
)


:individualsetup
echo Okay, choose which programs would you like to configure:
echo.
set /p HasNPM= Configure NPM? [Y]: || set HasNPM=Y
echo.
set /p HasWGET= Configure WGET? [Y]: || set HasWGET=Y
echo.
set /p HasCURL= Configure CURL? [Y]: || set HasCURL=Y
echo.
set /p HasRuby= Configure Ruby? [Y]: || set HasRuby=Y
echo.
set /p HasBower= Configure Bower? [Y]: || set HasBower=Y
echo.
set /p HasSSH= Configure SSH? [Y]: || set HasSSH=Y
set HasGit=N


:extraconfigs
if /i %HasSSH% == Y (
  set /p HasSSHConfig= [SSH Config] - Do you have existing SSH Hosts configured? [Y]: || set HasSSHConfig=Y
)

if /i %HasGit% == N (
  echo.
  set /p HasGit= Configure Git? [Y]: || set HasGit=Y
)

if /i %HasGit% == Y (
  set /p GitName= [Git Config] - What is the Full Name you use for Git?: || set GitName=""
  set /p GitEmail= [Git Config] - What email do you use for Git?: || set GitEmail=""
)

:: Create the config folder if it doesnt already exist
if not exist configs mkdir configs

:: NPM
if /i %HasNPM% == Y (
  echo proxy=%ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%
  echo strict-ssl=false
  echo loglevel=http
  echo loglevel=error
) >configs\npm.proxy-on.txt

if /i %HasNPM% == Y (
  echo loglevel=http
  echo loglevel=error
) >configs\npm.proxy-off.txt


:: Git
if /i %HasGit% == Y (
  echo  [user]
  echo    name = %GitName%
  echo    email = %GitEmail%
  echo [core]
  echo   autocrlf = true
  echo [http]
  echo   proxy = %ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%
  echo   sslVerify = false
) >configs\git.proxy-on.txt

if /i %HasGit% == Y (
  echo [user]
  echo   name = %GitName%
  echo   email = %GitEmail%
  echo [core]
  echo   autocrlf = true
) >configs\git.proxy-off.txt


:: Pull existing SSH Config setting. Things like Host configuration that haev already been set.
if /i %HasSSHConfig% == Y (

  set "var="
  set LF=^


  :: *** Two empty lines are required above this comment for the linefeed to work properly
  FOR /F "delims=" %%a in (%HOMEDRIVE%%HOMEPATH%\.ssh\config) do (
    set "var=!var!!LF!%%a"
  )
) else (
  set var = ""
)

:: SSH
if /i %HasSSH% == Y (
  echo ProxyCommand connect.exe -H %ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort% %%h %%p
  echo !var!
) >configs\ssh.proxy-on.txt

if /i %HasSSH% == Y (
  echo !var!
) >configs\ssh.proxy-off.txt


:: WGET
if /i %HasWGET% == Y  (
  echo http_proxy=%ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%
  echo https_proxy=%ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%
  echo use_proxy=on
  echo check_certificate = off
) >configs\wget.proxy-on.txt

if /i %HasWGET% == Y  (
  echo.
) >configs\wget.proxy-off.txt


::CURL
if /i %HasCURL% == Y  (
  echo http_proxy = %ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%
) >configs\curl.proxy-on.txt

if /i %HasCURL% == Y  (
  echo.
) >configs\curl.proxy-off.txt


:: Ruby
if /i %HasRuby% == Y (
  echo @ECHO OFF
  echo SET HTTP_PROXY=%ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%
  echo IF NOT "%%~f0" == "~f0" GOTO :WinNT
  echo ECHO.This version of Ruby has not been built with support for Windows 95/98/Me.
  echo GOTO :EOF
  echo :WinNT
  echo @"%%~dp0ruby.exe" "%%~dpn0" %%*
) >configs\ruby.proxy-on.txt

if /i %HasRuby% == Y (
  echo @ECHO OFF
  echo IF NOT "%%~f0" == "~f0" GOTO :WinNT
  echo ECHO.This version of Ruby has not been built with support for Windows 95/98/Me.
  echo GOTO :EOF
  echo :WinNT
  echo @"%%~dp0ruby.exe" "%%~dpn0" %%*
) >configs\ruby.proxy-off.txt


:: Bower
if /i %HasBower% == Y (
  echo {
  echo   "proxy":"%ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%",
  echo   "https-proxy":"%ProxyDomain%%ProxyUser%%ProxyPassword%%ProxyURL%:%ProxyPort%"
  echo }
) >configs\bower.proxy-on.txt

if /i %HasBower% == Y (
  echo.
) >configs\bower.proxy-off.txt

echo.
echo.
echo.
echo Config Files have been created^^!
echo.

set /p EnableProxy= Would you like to enable the proxy settings now? [N] || set EnableProxy=N

if /i %EnableProxy% == Y (
  call proxy-on.bat 2>errorlogs\proxy-toggle-log.txt
  goto proxyerrorcheck
) else (
  echo.
  echo Proxy settings were not enabled
  goto cleanup
)

:proxyerrorcheck
if exist errorlogs\proxy-toggle-log.txt (
  set /p ToggleError=<errorlogs\proxy-toggle-log.txt
) else (
  ToggleError = ""
)

if NOT "%ToggleError%" == """" (
  echo.
  echo Proxy configuration may have failed. Check your config files.
  goto cleanup
) else (
  echo.
  echo Proxy Configuration Successfully Enabled!
  del errorlogs\proxy-toggle-log.txt
)

:cleanup
for /F %%i in ('dir /b "errorlogs\*.*"') do (
  set ErrorHasFiles=%%i
)

if "%ErrorHasFiles%"=="" (
  :: No Files were in the errorlogs folder, so lets delete it
  goto removeemptyerror
) else (
  :: Error logs found, alert user
  echo.
  echo Error logs exist in "errorlogs" folder
  goto closeapp
)

:removeemptyerror
rmdir "errorlogs" /S /Q

:closeapp
echo.
echo Press any key to exit...
@pause >nul
@exit
