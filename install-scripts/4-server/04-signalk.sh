#!/bin/bash -e

## Dependencys of signalk.
apt-get install -y -q nodejs libavahi-compat-libdnssd-dev python-dev git

install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/plugin-config-data"
install -d -m 755 -o signalk -g signalk "/home/signalk/.signalk/node_modules/"

install -m 644 -o signalk -g signalk $FILE_FOLDER/set-system-time.json "/home/signalk/.signalk/plugin-config-data/"
install -m 644 -o signalk -g signalk $FILE_FOLDER/charts.json "/home/signalk/.signalk/plugin-config-data/"

install -m 644 -o signalk -g signalk $FILE_FOLDER/defaults.json "/home/signalk/.signalk/defaults.json"
install -m 644 -o signalk -g signalk $FILE_FOLDER/package.json "/home/signalk/.signalk/package.json"
install -m 644 -o signalk -g signalk $FILE_FOLDER/settings.json "/home/signalk/.signalk/settings.json"
install -m 644 -o signalk -g signalk $FILE_FOLDER/security.json "/home/signalk/.signalk/security.json"
install -m 755 -o signalk -g signalk $FILE_FOLDER/signalk-server "/home/signalk/.signalk/signalk-server"

install -d -o signalk -g signalk "/home/user/.local/share/icons/"
install -m 644 -o 1000 -g 1000 $FILE_FOLDER/icons/signalk.png "/home/user/.local/share/icons/"

install -d /etc/systemd/system
install -m 644 $FILE_FOLDER/signalk.service "/etc/systemd/system/signalk.service"
install -m 644 $FILE_FOLDER/signalk.socket "/etc/systemd/system/signalk.socket"

systemctl enable signalk.service
systemctl enable signalk.socket

## Install signalk
npm cache clean --force
npm install -g --unsafe-perm signalk-server
npm cache clean --force

## Install signalk published plugin
pushd /home/signalk/.signalk
  su signalk -c "npm install @signalk/charts-plugin --unsafe-perm --loglevel error"
  su signalk -c "npm install @mxtommy/kip --unsafe-perm --loglevel error"
  #su signalk -c "npm install signalk-world-coastline-map --unsafe-perm --loglevel error"
popd

## Install signalk lysmarine-dashboard plugin
pushd /home/signalk/.signalk/node_modules/@signalk/
  su signalk -c "git clone https://github.com/lysmarine/lysmarine-dashboard"
  pushd ./lysmarine-dashboard
    rm -rf .git
    npm install
  popd
popd

## Give set-system-time the possibility to change the date.
echo "signalk ALL=(ALL) NOPASSWD: /bin/date" >>/etc/sudoers

## Make some space on the drive for the next stages
npm cache clean --force
