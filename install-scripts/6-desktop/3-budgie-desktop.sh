#!/bin/bash -e

apt-get install -y libatk-adaptor libgtk2.0-dev

apt-get install -y libatk1.0-0 libcairo2 libfontconfig1 libfreetype6 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk2.0-0 \
  libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 librsvg2-common libx11-6
 
apt-get install -y budgie-desktop

## Start budgie-desktop on openbox boot.
install -o 1000 -g 1000 -d /home/user/.config/openbox
echo 'chromium --headless &' >>/home/user/.config/openbox/autostart
echo 'budgie-desktop &' >>/home/user/.config/openbox/autostart
