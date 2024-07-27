# BlueGreenTest

sudo dnf install -y python3-pip git nginx
pip install virtualenv

git clone https://github.com/saitou-cpi/BlueGreenTest.git
virtualenv .venv
source .venv/bin/activate
cd BlueGreenTest/
pip install -r requirements.txt

# blue.sevice and green.service copy
sudo cp /home/ec2-user/BlueGreenTest/service_files/blue.service /etc/systemd/system/blue.service
sudo cp /home/ec2-user/BlueGreenTest/service_files/green.service /etc/systemd/system/green.service

# Reload
sudo systemctl daemon-reload

# 
sudo systemctl enable blue.service
sudo systemctl enable green.service

# Start services
sudo systemctl start blue.service
sudo systemctl start green.service

# Check status
sudo systemctl status blue.service
sudo systemctl status green.service
