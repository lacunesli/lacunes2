#!/bin/bash
#set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up klipper"

echo -e "${COL}Installing dependencies...\n${NC}"
apk add py3-cffi py3-greenlet linux-headers can-utils python3-dev build-base gcc g++
pip3 install python-can

echo -e "${COL}Downloading klipper\n${NC}"
curl -o klipper.zip -L https://ghproxy.com/https://github.com/Klipper3d/klipper/archive/refs/heads/master.zip

echo -e "${COL}Extracting klipper\n${NC}"
unzip klipper.zip
rm -rf klipper.zip
mv klipper-master /klipper

mkdir /root/klipper_config
echo "# replace with your config" >> /root/klipper_config/printer.cfg

mkdir -p /root/extensions/klipper
cat << EOF > /root/extensions/klipper/manifest.json
{
        "title": "Klipper plugin",
        "description": "Requires OctoKlipper plugin"
}
EOF

cat << EOF > /root/extensions/klipper/start.sh
#!/bin/sh
python3 /klipper/klippy/klippy.py /root/klipper_config/printer.cfg -l /tmp/klippy.log -a /tmp/klippy_uds
EOF

cat << EOF > /root/extensions/klipper/kill.sh
#!/bin/sh
pkill -f 'klippy\.py'
EOF
chmod +x /root/extensions/klipper/start.sh
chmod +x /root/extensions/klipper/kill.sh
chmod 777 /root/extensions/klipper/start.sh
chmod 777 /root/extensions/klipper/kill.sh

echo -e "${COL}\nKlipper installed!${NC}"
