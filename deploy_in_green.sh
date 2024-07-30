#!/bin/bash
# Blue → Green

# Pull latest code
git pull origin main

# Apply changes to the green environment
cp -r ./new_code/* ./green/

# Restart the green environment (assumes you are using a systemd service or similar)
sudo systemctl restart green.service

# Wait for a manual confirmation before promoting green to production
echo "http://example.com/green を確認し、問題なければ 'y'、問題がある場合は 'Ctrl+C' を押してください..."
read -n 1 -s

# Swap upstream environment to point to green as the main environment
sudo sed -i 's/set $upstream_env blue;/set $upstream_env green;/g' /etc/nginx/nginx.conf
sudo nginx -s reload

# Restart both environments to apply the new configuration
sudo systemctl restart blue.service
sudo systemctl restart green.service

echo "Deployment complete. Green is now the new production environment."
