#!/bin/bash -e
rm -rf  /tmp/empty-cache46
rm -rvf /home/user/Public /home/user/Templates 

apt-get clean

apt-get remove -y greybird-gtk-theme murrine-themes rpd-icons

apt-get -y autoremove
apt-get clean
npm cache clean --force

# remove python pip cache
rm -rf ~/.cache/pip

# remove all cache
rm -rf ~/.cache
rm -rf ~/.config
rm -rf ~/.npm
rm -rf ~/.wget*



