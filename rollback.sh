#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {blue|green}"
    exit 1
fi

ROLLBACK_ENV=$1

if [ "$ROLLBACK_ENV" == "blue" ]; then
    CURRENT_ENV="green"
elif [ "$ROLLBACK_ENV" == "green" ]; then
    CURRENT_ENV="blue"
else
    echo "Invalid environment: $ROLLBACK_ENV"
    echo "Usage: $0 {blue|green}"
    exit 1
fi

# Wait for a manual confirmation before rolling back
echo "Rolling back to $ROLLBACK_ENV environment. Press 'y' to confirm, or 'Ctrl+C' to cancel."
read -n 1 -s

# Swap upstream environment to point back to the rollback environment
if [ "$ROLLBACK_ENV" == "blue" ]; then
    sudo sed -i 's/set $upstream_env green;/set $upstream_env blue;/g' /etc/nginx/nginx.conf
else
    sudo sed -i 's/set $upstream_env blue;/set $upstream_env green;/g' /etc/nginx/nginx.conf
fi

sudo nginx -s reload

# Restart both environments to apply the old configuration
sudo systemctl restart blue.service
sudo systemctl restart green.service

echo "Rollback complete. $ROLLBACK_ENV is now the new production environment."
