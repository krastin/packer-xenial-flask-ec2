#!/usr/bin/env bash

## Standard boostrap

apt-get update

# Add no-password sudo config for vagrant user
useradd flask
echo "%flask ALL=NOPASSWD:ALL" > /etc/sudoers.d/flask
chmod 0440 /etc/sudoers.d/flask

# Add flask to sudo group
usermod -a -G sudo flask

# Install NFS
apt-get install -y nfs-common
# Without libdbus virtualbox would not start automatically after compile
apt-get -y install --no-install-recommends libdbus-1-3

# Install Linux headers and compiler toolchain
apt-get -y install build-essential linux-headers-$(uname -r)

apt-get install -y dkms

# unattended apt-get upgrade
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

## Box specific provision
# Install python3 flask and dummy website
apt-get -y install python3-pip policykit-1
python3 -m pip install --user --upgrade pip==9.0.3
pip3 install virtualenv flask jinja2 Flask-And-Redis
echo 'export LC_ALL="en_US.UTF-8"' >> /etc/bash.bashrc
echo 'export LC_CTYPE="en_US.UTF-8"' >> /etc/bash.bashrc
mkdir -p /home/flask/flask-website
cat <<EOF > /etc/systemd/system/flask-website.service
[Unit]
Description=Microwebsite application
After=network.target

[Service]
User=flask
WorkingDirectory=/home/flask/flask-website
Environment=FLASK_ENV=development
Environment=FLASK_APP=project.py
Environment=FLASK_RUN_PORT=8080
Environment=REDIS_HOST=127.0.0.1
ExecStart=/usr/local/bin/flask run
Restart=always

[Install]
WantedBy=multi-user.target
EOF
cat <<EOF > /home/flask/flask-website/project.py
#!/usr/bin/python
from flask import Flask, escape, request

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World!'
EOF
systemctl enable flask-website

# Install some tools
apt-get -y install jq curl unzip vim tmux cloud-init

# Install reverse proxy rerouting to high ports >1024
apt-get -y install nginx
cat <<EOF > /etc/nginx/sites-available/flask-website
server {
    listen 80;
    location / {
        proxy_pass http://127.0.0.1:8080/;
    }
}
EOF
rm -rf /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/flask-website /etc/nginx/sites-enabled/
systemctl enable nginx

apt-get autoremove -y
apt-get clean

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

# Zero out the free space to save space in the final image:
echo "Zeroing device to make space..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
