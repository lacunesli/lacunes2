#!/bin/bash

#set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up moonraker"

echo -e "${COL}Installing dependencies...\n${NC}"
apk add curl curl-dev jpeg-dev python3-dev py3-lmdb py3-wheel

echo -e "${COL}Downloading moonraker\n${NC}"
curl -o moonraker.zip -L https://gitee.com/diy-3d/Octo4a/raw/master/moonraker.zip

echo -e "${COL}Extracting moonraker\n${NC}"
unzip moonraker.zip
echo -e "${COL}Finished extracting\n${NC}"
rm -rf moonraker.zip
mv moonraker /moonraker

# pip3 install -U pip setuptools wheel
cd /moonraker/

for n in tornado pyserial pillow lmdb libnacl paho-mqtt pycurl streaming-form-data
do
  sed -i "s#$n.*#$n#" ./scripts/moonraker-requirements.txt
done
pip3 install -r scripts/moonraker-requirements.txt

#mkdir /root/klipper_config
curl -o /root/klipper_config/moonraker.conf -C - https://gitee.com/diy-3d/Octo4a/raw/master/moonraker.conf

echo -e "${COL} Applying special sauce${NC}"
sed -i 's/max_dbs=MAX_NAMESPACES)/max_dbs=MAX_NAMESPACES, lock=False)/' /moonraker/moonraker/components/database.py

mkdir -p /root/extensions/moonraker
cat << EOF > /root/extensions/moonraker/manifest.json
{
        "title": "Moonraker plugin",
        "description": "Requires Klipper"
}
EOF

cat << EOF > /root/extensions/moonraker/start.sh
#!/bin/sh
LD_PRELOAD=/home/octoprint/ioctlHook.so python3 /moonraker/moonraker/moonraker.py -c /root/klipper_config/moonraker.conf -l /tmp/moonraker.log
EOF

cat << EOF > /root/extensions/moonraker/kill.sh
#!/bin/sh
pkill -f 'moonraker\.py'
EOF
chmod +x /root/extensions/moonraker/start.sh
chmod +x /root/extensions/moonraker/kill.sh
chmod 777 /root/extensions/moonraker/start.sh
chmod 777 /root/extensions/moonraker/kill.sh

mkdir /home/octoprint/gcode_files
# printer.cfg:
# [virtual_sdcard]
# path: /home/octoprint/gcode_files

cat << EOF
Moonraker installed!
EOF