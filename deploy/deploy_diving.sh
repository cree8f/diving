#!/usr/bin/env bash
# Usage on EC2 (run as sudo or via sudo for individual commands)
# 1) Copy files from repo to EC2 (via scp)
#  scp deploy/gunicorn.diving.service ubuntu@<EC2-IP>:/tmp/
#  scp deploy/nginx.diving.conf ubuntu@<EC2-IP>:/tmp/
# 2) On EC2, run the following commands:

# stop existing gunicorn on 127.0.0.1:8000 if any
# sudo pkill -f "gunicorn.*127.0.0.1:8000" || true

# install python deps and gunicorn if not already installed
# sudo apt-get update
# sudo apt-get install -y python3-pip nginx
# sudo python3 -m pip install -r /home/ubuntu/DivinG_BAZ/requirements.txt
# sudo python3 -m pip install --user gunicorn

# install systemd unit
sudo mv /tmp/gunicorn.diving.service /etc/systemd/system/gunicorn.service
sudo systemctl daemon-reload
sudo systemctl enable --now gunicorn
sudo systemctl status --no-pager gunicorn || true

# install nginx site
sudo mv /tmp/nginx.diving.conf /etc/nginx/sites-available/diving
sudo ln -sfn /etc/nginx/sites-available/diving /etc/nginx/sites-enabled/diving
sudo nginx -t && sudo systemctl reload nginx

# allow firewall (if using ufw)
# sudo ufw allow 'Nginx Full' || true

# Obtain TLS certs with certbot (optional)
# sudo apt-get install -y certbot python3-certbot-nginx
# sudo certbot --nginx -d diving.onemedia.asia -d www.diving.onemedia.asia

# Verify
# curl -I http://diving.onemedia.asia/
