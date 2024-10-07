#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt full-upgrade -y
sudo apt install -f -y
sudo apt autoremove --purge -y
sudo apt autoclean -y
sudo apt clean -y
#flatpak update -y
sudo snap refresh
sudo apt-file update
