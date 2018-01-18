#!/bin/bash

# $HOME/../../Program\ Files/Oracle/VirtualBox/VBoxManage.exe list ostypes
#~/../../"Program Files"/Oracle/VirtualBox/VBoxManage.exe list ostypes

VM='Ubuntu-16.04.2-64bit'
~/../../Program\ Files/Oracle/VirtualBox/VBoxManage.exe createhd --filename $VM.vdi --size 32768
#~/../../Program\ Files/Oracle/VirtualBox/VBoxManage.exe createvm --name $VM --ostype "Ubuntu_64" --register
