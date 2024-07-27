#!/bin/bash

# Pull latest code
git pull origin main

# Apply changes to the green environment
cp -r ./new_code/* ./green/

# Restart the green environment
systemctl restart green.service

# Wait for a manual confirmation before promoting green to production
echo "http://example.com/green を確認し、問題なければ 'y'、問題がある場合は 'Ctrl+C' を押してください..."
read -n 1 -s -p ""

# Swap nginx config to print to green as the main environment
sed -i 's/8000/8001/g' /etc/nginx/sites-available/default
nginx -s reload

# Swap the directories
mv ./blue ./blue_old
mv ./green ./blue
mv ./blue_old ./green

# Restart both environments
systemctl restart blue.servise
systemctl restart green.service

echo "Deplotment complete. Blue is now running on port 8001 and green on port 8000."