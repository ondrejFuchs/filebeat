#!/bin/bash  -xe
# Instalace Go ve verzi 1.9.2
wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
sudo tar -zxvf go1.9.2.linux-amd64.tar.gz -C /usr/local
rm go1.9.2.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
# Build filebeat
mkdir -p work
PATHTOWORK="$(readlink -f work)"

export GOPATH=${PATHTOWORK}
cd ${PATHTOWORK}
mkdir -p src/github.com/elastic/
cd src/github.com/elastic/
rm -rf beats
git clone https://github.com/elastic/beats.git
cd beats/filebeat/
GOARCH=arm go build
cp filebeat ${PATHTOWORK}
cd ${PATHTOWORK}
ls -l
rm -rf src


#Source https://discuss.elastic.co/t/how-to-install-filebeat-on-a-arm-based-sbc-eg-raspberry-pi-3/103670/3
