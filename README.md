# FedoraWSL
Fedora on WSL (Windows 10 FCU or later)
based on [wsldl](https://github.com/yuk7/wsldl)

![screenshot](https://raw.githubusercontent.com/sileshn/FedoraWSL/master/img/screenshot.png)

[![CircleCI](https://circleci.com/gh/yosukes-dev/FedoraWSL.svg?style=svg)](https://circleci.com/gh/yosukes-dev/FedoraWSL2)
[![Github All Releases](https://img.shields.io/github/downloads/yosukes-dev/FedoraWSL/total.svg?style=flat-square)](https://github.com/yosukes-dev/FedoraWSL/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![License](https://img.shields.io/github/license/yosukes-dev/FedoraWSL.svg?style=flat-square)

## Requirements
* Windows 10 Fall Creators Update x64 or later. (Testing Environment: WSL:build.18363, WSL2:build.19569)
* Windows Subsystem for Linux feature is enabled.

## Install
1. [Download](https://github.com/sileshn/FedoraWSL/releases) installer zip
2. Extract all files in zip file to same directory
3. Run Fedora.exe to Extract rootfs and Register to WSL

#### Exe filename is using the instance name to register. If you rename it you can register with a diffrent name and have multiple installs.

If you want to use WSL2 after install, convert it with the following command.
```dos
wsl --set-version Fedora 2
```

You can also set wsl2 as default. Use the command below before running Fedora.exe.
```dos
wsl --set-default-version 2
```

## How-to-Use(for Installed Instance)
#### exe Usage
```dos
Usage :
    <no args>
      - Open a new shell with your default settings.

    run <command line>
      - Run the given command line in that distro. Inherit current directory.

    runp <command line (includes windows path)>
      - Run the path translated command line in that distro.

    config [setting [value]]
      - `--default-user <user>`: Set the default user for this distro to <user>
      - `--default-uid <uid>`: Set the default user uid for this distro to <uid>
      - `--append-path <on|off>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <on|off>`: Switch of Mount drives

    get [setting]
      - `--default-uid`: Get the default user uid in this distro
      - `--append-path`: Get on/off status of Append Windows PATH to $PATH
      - `--mount-drive`: Get on/off status of Mount drives
      - `--lxguid`: Get WSL GUID key for this distro

    backup [contents]
      - `--tgz`: Output backup.tar.gz to the current directory using tar command
      - `--reg`: Output settings registry file to the current directory

    clean
      - Uninstall the distro.

    help
      - Print this usage message.
```
## How to setup

Open Fedora.exe and run the following commands.
```dos
passwd
sudo sed -i 's#\# %wheel ALL=(ALL) ALL#%wheel ALL=(ALL) ALL#g' /etc/sudoers
useradd -m -G wheel -s /bin/bash <username>
passwd <username>
exit
```
Execute the command below in a windows cmd terminal from the directory where Fedora.exe is installed.
```dos
>Fedora.exe config --default-user <username>
```

## How to uninstall instance
```dos
>Fedora.exe clean

```
