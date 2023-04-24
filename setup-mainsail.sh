#!/bin/bash

#set -e
COL='\033[1;32m'
NC='\033[0m' # No Color
echo -e "${COL}Setting up mainsail"

echo -e "${COL}Installing dependencies...\n${NC}"
apk add curl nginx openrc

echo -e "${COL}Downloading mainsail\n${NC}"
mkdir /mainsail && cd /mainsail
curl -o mainsail.zip -L https://gitee.com/Neko-vecter/mainsail-releases/releases/download/v2.4.1/mainsail.zip

echo -e "${COL}Extracting mainsail\n${NC}"
unzip mainsail.zip
rm -rf mainsail.zip

rm /etc/nginx/http.d/default.conf
curl -o /etc/nginx/http.d/mainsail.conf -C - https://gitee.com/diy-3d/Octo4a/raw/master/mainsail.conf

mkdir -p /root/extensions/mainsail
cat << EOF > /root/extensions/mainsail/manifest.json
{
        "title": "mainsail plugin",
        "description": "klipper web interface"
}
EOF

cat << EOF > /root/extensions/mainsail/start.sh
#!/bin/sh
nginx
EOF

cat << EOF > /root/extensions/mainsail/kill.sh
#!/bin/sh
nginx -s stop
EOF

chmod +x /root/extensions/mainsail/start.sh
chmod +x /root/extensions/mainsail/kill.sh
chmod 777 /root/extensions/mainsail/start.sh
chmod 777 /root/extensions/mainsail/kill.sh

cat << EOF
mainsail installed!
EOF