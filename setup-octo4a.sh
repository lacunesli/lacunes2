#!/bin/sh

set -e
apk add py3-pip py3-yaml py3-regex py3-netifaces py3-psutil unzip py3-pillow ttyd ffmpeg git tzdata
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone

mkdir -p /root/extensions/ttyd
cat << EOF > /root/extensions/ttyd/manifest.json
{
        "title": "Remote web terminal (ttyd)",
        "description": "Uses port 5002; User root / ssh password"
}
EOF

#echo "octoprint" > /root/.octoCredentials
cat << EOF > /root/extensions/ttyd/start.sh
#!/bin/sh
ttyd -p 5002 --credential root:\$(cat /root/.octoCredentials) bash
EOF

cat << EOF > /root/extensions/ttyd/kill.sh
#!/bin/sh
pkill ttyd
EOF

chmod +x /root/extensions/ttyd/start.sh
chmod +x /root/extensions/ttyd/kill.sh
chmod 777 /root/extensions/ttyd/start.sh
chmod 777 /root/extensions/ttyd/kill.sh

pip3 install -U packaging --ignore-installed
pip3 install https://ghproxy.com/https://github.com/feelfreelinux/octo4a-argon2-mock/archive/main.zip
pip3 install --upgrade setuptools wheel tornado --no-cache-dir
touch /home/octoprint/.argon-fix
