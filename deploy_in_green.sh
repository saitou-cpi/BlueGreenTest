#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {blue|green}"
    exit 1
fi

DEPLOY_ENV=$1
UPSTREAM_ENV=""

if [ "$DEPLOY_ENV" == "blue" ]; then
    UPSTREAM_ENV="green"
    TARGET_DIR="./blue/"
    SERVICE_NAME="blue.service"
elif [ "$DEPLOY_ENV" == "green" ]; then
    UPSTREAM_ENV="blue"
    TARGET_DIR="./green/"
    SERVICE_NAME="green.service"
else
    echo "Invalid environment: $DEPLOY_ENV"
    echo "Usage: $0 {blue|green}"
    exit 1
fi

# Pull latest code
git pull origin main

# Apply changes to the target environment
cp -r ./new_code/* $TARGET_DIR

# Restart the target environment (assumes you are using a systemd service or similar)
sudo systemctl restart $SERVICE_NAME

# Wait for a manual confirmation before promoting to production
echo "http://example.com/$DEPLOY_ENV を確認し、問題なければ 'y'、問題がある場合は 'Ctrl+C' を押してください..."
read -n 1 -s

# Swap upstream environment to point to the target as the main environment
if [ "$DEPLOY_ENV" == "blue" ]; then
    sudo sed -i 's/set $upstream_env green;/set $upstream_env blue;/g' /etc/nginx/nginx.conf
else
    sudo sed -i 's/set $upstream_env blue;/set $upstream_env green;/g' /etc/nginx/nginx.conf
fi

sudo nginx -s reload

# Restart both environments to apply the new configuration
sudo systemctl restart blue.service
sudo systemctl restart green.service

echo "Deployment complete. $DEPLOY_ENV is now the new production environment."
