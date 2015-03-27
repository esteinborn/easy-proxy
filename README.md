# Easy Proxy
> **The proxy switcher for Windows you've always needed but didn't have the time to develop.**

This script installs a collection of proxy configuration files for 7 different programs: NPM, Git, SSH, Bower, CURL, WGET, and Ruby. I have amassed this list through many years of fighting proxies. It is my gift to you, the Proxied developer. Keep fighting the good fight!

This application covers proxy configurations for the following applications:

> npm
> bower
> curl
> wget
> git
> ssh
> Ruby 1.93

## Setup Instructions

1. Run `setup.bat`
2. Follow the prompts, pressing ENTER to accept the [default] for each prompt
3. After config files have been created, you can choose to automatically enable the proxy at the end.

## Check for Pre-configured Settings

1. Check each file in the `/backup` folder (`NAME.txt`). Compare to the new file created in `/config`
  a. Copy any pre-existing settings from the old file to the new `.proxy-on` file
  b. Copy any pre-existing settings from the old file to the new `.proxy-off` file
2. Save the file
3. Repeat 1-2 for all `.proxy-on/off` files

# For Users Who Switch Proxies Frequently

## Toggling Proxy Settings On and Off

1. Run the `proxy-on.bat`/`proxy-off.bat` file
2. All your favorite applications have now been configured

## Making CLI changes to config files

When making CLI changes to any of the software config files, it will only change the file that is currently in use, it will not change the proxy-on and proxy-off versions of that file. To make CLI changes like `git config global.email` you'll need to edit the git files in the configs folder in order to make them stick.


## Using Proxyswitcher (if you travel on and off proxied networks)

### Install Proxy Switcher: http://proxyswitcher.net/

1. After installing proxy switcher, configure it for your network.
2. Click the option ADD ACTION and EXECUTE SCRIPT
3. For when you need a proxy on, choose the `proxy-on.bat` file
4. For when you need a proxy off, choose the `proxy-off.bat` file
