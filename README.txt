# BlueGreenTest

# セッティング
sudo dnf install -y python3-pip git nginx
pip install virtualenv

git clone https://github.com/saitou-cpi/BlueGreenTest.git
virtualenv .venv
source .venv/bin/activate
cd BlueGreenTest/
pip install -r requirements.txt

sudo chmod u+x deploy.sh check_default_env.sh rollback.sh 

# blue.sevice and green.service copy
sudo cp /home/ec2-user/BlueGreenTest/service_files/blue.service /etc/systemd/system/blue.service
sudo cp /home/ec2-user/BlueGreenTest/service_files/green.service /etc/systemd/system/green.service

# Reload
sudo systemctl daemon-reload

# 
sudo systemctl enable blue.service
sudo systemctl enable green.service

sestatus

getenforce


# Start services to trigger SELinux denials
sudo systemctl start blue.service
sudo systemctl start green.service

sudo systemctl restart blue.service
sudo systemctl restart green.service

# Generate SELinux policy module from audit logs
sudo cat /var/log/audit/audit.log | grep "gunicorn"
sudo grep "gunicorn" /var/log/audit/audit.log | audit2allow -M custom_policy



# Apply the generated SELinux policy module
sudo semodule -i custom_policy.pp


# Restart services to apply the new SELinux policy
sudo systemctl restart blue.service
sudo systemctl restart green.service

# Check status
sudo systemctl status blue.service
sudo systemctl status green.service

rm custom_policy.*

# Startign nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Setting nginx
sudo cp /home/ec2-user/BlueGreenTest/nginx/nginx.conf /etc/nginx/nginx.conf
sudo nginx -t
sudo nginx -s reload
sudo systemctl status nginx


# 使い方
# 現在のデフォルト環境を確認する場合
./check_default_env.sh

# Blue環境にデプロイする場合
./deploy.sh blue

# Green環境にデプロイする場合
./deploy.sh green

# Blue環境にロールバックする場合
./rollback.sh blue

# Green環境にロールバックする場合
./rollback.sh green
