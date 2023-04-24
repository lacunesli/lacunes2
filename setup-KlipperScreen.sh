#!/bin/bash

#set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up KlipperScreen"

echo -e "${COL}Installing dependencies...\n${NC}"
apk add cmake xorg-server cairo-dev dbus dbus-libs gobject-introspection-dev py3-dbus-dev librsvg-dev gtk+3.0 terminus-font ttf-inconsolata ttf-dejavu font-noto font-noto-cjk ttf-font-awesome font-noto-extra font-isas-misc

echo -e "${COL}Downloading KlipperScreen\n${NC}"
git clone https://gitee.com/Neko-vecter/KlipperScreen.git /KlipperScreen
echo -e "${COL}Setting up KlipperScreen\n${NC}"

virtualenv /KlipperScreen-env
source /KlipperScreen-env/bin/activate
pip install -r /KlipperScreen/scripts/KlipperScreen-requirements.txt
deactivate

curl -o /root/klipper_config/KlipperScreen.conf -C - https://gitee.com/diy-3d/Octo4a/raw/master/KlipperScreen.conf
curl -o /root/ks.sh -C - https://gitee.com/diy-3d/Octo4a/raw/master/ks.sh

mkdir -p /root/extensions/KlipperScreen
cat << EOF > /root/extensions/KlipperScreen/manifest.json
{
        "title": "KlipperScreen plugin",
        "description": "klipper touchscreen GUI"
}
EOF

cat << EOF > /root/extensions/KlipperScreen/start.sh
#!/bin/sh
cd /KlipperScreen
DISPLAY=localhost:0 /KlipperScreen-env/bin/python3 /KlipperScreen/screen.py
EOF

cat << EOF > /root/extensions/KlipperScreen/kill.sh
#!/bin/sh
pkill -f 'screen\.py'
EOF

chmod +x /root/extensions/KlipperScreen/start.sh
chmod +x /root/extensions/KlipperScreen/kill.sh
chmod +x /root/ks.sh

cat << EOF
KlipperScreen installed!
EOF