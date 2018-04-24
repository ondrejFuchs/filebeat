#!/bin/bash
# Path to home
HOMEPATH="$(readlink -f .)"
# Path to artifact from Fileabeats_ARM
PATH_TO_FILEBEAT_AMD="$(readlink -f work)"
# Path to work direcroty
mkdir -p work_filebeat
PATH_TO_WORK="$(readlink -f work_filebeat)"

mkdir -p filebeat
PATH_TO_FILEBEAT="$(readlink -f filebeat)"

mkdir -p filebeatPackage
PATH_TO_FILEBEAT_PACKAGE="$(readlink -f filebeatPackage)"

cd ${PATH_TO_WORK}
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.0.1-darwin-x86_64.tar.gz
tar xzvf filebeat-6.0.1-darwin-x86_64.tar.gz
rm -r -f filebeat-6.0.1
mv filebeat-6.0.1-darwin-x86_64 filebeat-6.0.1
# Kopírování nejnovějšího ./filebeat
cp ${PATH_TO_FILEBEAT_AMD}/filebeat ${PATH_TO_WORK}/filebeat-6.0.1/
rm -f ${PATH_TO_WORK}/filebeat-6.0.1-darwin-x86_64.tar.gz

# Aktualizace filebeat.yml 
mv ${HOMEPATH}/filebeat.yml ${PATH_TO_WORK}/filebeat-6.0.1/

# Make structure for filebeat.deb
cd ${PATH_TO_FILEBEAT}
mkdir -p DEBIAN
mkdir -p usr/bin/filebeat
mkdir -p lib/systemd/system

cp -a -n ${PATH_TO_WORK}/filebeat-6.0.1/* ${PATH_TO_FILEBEAT}/usr/bin/filebeat

filename=${PATH_TO_FILEBEAT}/lib/systemd/system/filebeat.service
test -f $filename || touch $filename

filename=${PATH_TO_FILEBEAT}/DEBIAN/control
test -f $filename || touch $filename

filename=${PATH_TO_FILEBEAT}/DEBIAN/changelog
test -f $filename || touch $filename

filename=${PATH_TO_FILEBEAT}/DEBIAN/copyright
test -f $filename || touch $filename

filename=${PATH_TO_FILEBEAT}/DEBIAN/postinst
test -f $filename || touch $filename
chmod 775 $filename

echo "[Unit]
Description=filebeat
Documentation=https://www.elastic.co/guide/en/beats/filebeat/current/index.html
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/bin/filebeat/filebeat -c /usr/bin/filebeat/filebeat.yml
Restart=always

[Install]
WantedBy=multi-user.target" > ${PATH_TO_FILEBEAT}/lib/systemd/system/filebeat.service

echo "Package: nsw-filebeat
Version: 1.0
Section: web
Priority: optional
Depends: libc6 (>= 2.2.4-4)
Architecture: all
Essential: no
Maintainer: Ondrej Fuchs
Description: Package for filebeat run on Rpi
  Package is make fot NSW run on Rpi" > ${PATH_TO_FILEBEAT}/DEBIAN/control

echo "Files: *
Copyright: Filebeat
License: via LICENCE.txt" > ${PATH_TO_FILEBEAT}/DEBIAN/copyright

echo "# Changelog
All notable changes to this project will be documented in this file.
" > ${PATH_TO_FILEBEAT}/DEBIAN/changelog

echo "#!/bin/sh
sudo systemctl enable filebeat
sudo service filebeat start
" > ${PATH_TO_FILEBEAT}/DEBIAN/postinst

cd ${PATH_TO_FILEBEAT}
find * -type f ! -regex '^DEBIAN/.*' -exec md5sum {} \; > DEBIAN/md5sums

echo "App: Structure of folder is ready to make .deb"

cd ${PATH_TO_FILEBEAT}
cd ..
sudo chown -hR root:root filebeat
sudo dpkg-deb -b filebeat nsw-filebeat.deb

echo "App: Build filebeat.deb"

sudo rm -r -f ${PATH_TO_FILEBEAT}
sudo rm -r -f ${PATH_TO_WORK}

mv  nsw-filebeat.deb ${PATH_TO_FILEBEAT_PACKAGE}/

              
