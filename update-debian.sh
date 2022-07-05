#!/bin/bash
apt update
apt upgrade -y
apt dist-upgrade -y
apt full-upgrade -y
apt install -f -y
apt autoremove --purge -y
