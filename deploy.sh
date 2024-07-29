#!/bin/bash

# Pull latest code
git pull origin main

# Apply changes to the green environment
cp -r ./new_code/* ./green/

# Restart the green environment (assumes you are using a systemd service or similar)
sudo systemctl restart green.service

# Wait for a manual confirmation before promoting green to production
echo "http://example.com/green を確認し、問題なければ 'y'、問題がある場合は 'Ctrl+C' を押してください..."
read -n 1 -s

# Swap nginx config to point to green as the main environment
sudo sed -i 's/8000/8001/g' /etc/nginx/nginx.conf
sudo nginx -s reload

# Swap the directories
mv ./blue ./blue_old
mv ./green ./blue
mv ./blue_old ./green

# Restart both environments
sudo systemctl restart blue.service
sudo systemctl restart green.service

echo "Deployment complete. Blue is now running on port 8001 and green on port 8000."
