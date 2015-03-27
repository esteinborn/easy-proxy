@echo off
setlocal EnableDelayedExpansion

call backup.bat

:: Backup makes a mess on the screen, lets clean it up
cls

echo.
echo Configure your proxy settings. Press enter to accept [defaults]
echo.

set /p ProxyURL= What is your Proxy URL (NO port, HTTP included)? [http://yourproxy.com]: || set ProxyURL=http://yourproxy.com
echo.
set /p ProxyPort= What is your Proxy Port? [80]: || set ProxyPort=80
echo.
set /p HasNPM= Do you need to set up NPM? [Y]: || set HasNPM=Y
echo.
set /p HasWGET= Do you need to set up WGET? [Y]: || set HasWGET=Y
echo.
set /p HasCURL= Do you need to set up CURL? [Y]: || set HasCURL=Y
echo.
set /p HasRuby= Do you need to set up Ruby? [Y]: || set HasRuby=Y
echo.
set /p HasBower= Do you need to set up Bower? [Y]: || set HasBower=Y
echo.
set /p HasSSH= Do you need to set up SSH? [Y]: || set HasSSH=Y
if /i %HasSSH% == Y (
  set /p HasSSHConfig= [SSH Config] - Do you have existing SSH Hosts configured? [Y]: || set HasSSHConfig=Y
)
echo.
set /p HasGit= Do you need to set up Git? [Y]: || set HasGit=Y

if /i %HasGit% == Y (
  set /p GitName= [Git Config] - What is the Full Name you use for Git?:
  set /p GitEmail= [Git Config] - What email do you use for Git?:
)
echo.


:: Create the config folder if it doesnt already exist
if not exist configs mkdir configs

:: NPM
if /i %HasNPM%==Y (
  echo proxy=%ProxyURL%:%ProxyPort%
  echo strict-ssl=false
  echo loglevel=http
) >configs\npm.proxy-on.txt

if /i %HasNPM%==Y (
  echo loglevel=http
) >configs\npm.proxy-off.txt


:: Git
if /i %HasGit% == Y (
  echo  [user]
  echo    name = %GitName%
  echo    email = %GitEmail%
  echo [core]
  echo   autocrlf = true
  echo [http]
  echo   proxy = %ProxyURL%:%ProxyPort%
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
  echo ProxyCommand connect.exe -H %ProxyURL%:%ProxyPort% %%h %%p
  echo !var!
) >configs\ssh.proxy-on.txt

if /i %HasSSH% == Y (
  echo !var!
) >configs\ssh.proxy-off.txt


:: WGET
if /i %HasWGET% == Y  (
  echo http_proxy=%ProxyURL%:%ProxyPort%
  echo https_proxy=%ProxyURL%:%ProxyPort%
  echo use_proxy=on
  echo check_certificate = off
) >configs\wget.proxy-on.txt

if /i %HasWGET% == Y  (
  echo.
) >configs\wget.proxy-off.txt


::CURL
if /i %HasCURL% == Y  (
  echo http_proxy = %ProxyURL%:%ProxyPort%
) >configs\curl.proxy-on.txt

if /i %HasCURL% == Y  (
  echo.
) >configs\curl.proxy-off.txt


:: Ruby
if /i %HasRuby% == Y (
  echo @ECHO OFF
  echo SET HTTP_PROXY=%ProxyURL%:%ProxyPort%
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
  echo   "proxy":"%ProxyURL%:%ProxyPort%",
  echo   "https-proxy":"%ProxyURL%:%ProxyPort%"
  echo }
) >configs\bower.proxy-on.txt

if /i %HasBower% == Y (
  echo.
) >configs\bower.proxy-off.txt


echo.
echo Config Files have been created.
echo.

set /p EnableProxy= Would you like to enable the proxy settings now? [N] || set EnableProxy=N

if /i %EnableProxy% == Y (
  call proxy-on.bat
  echo Proxy Configuration Enabled!
)

echo.
echo Proxy Setup Complete! Press any key to exit...
@pause >nul
@exit