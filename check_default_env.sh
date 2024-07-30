#!/bin/bash

# Define the path to the NGINX configuration file
NGINX_CONF="/etc/nginx/nginx.conf"

# Check if the NGINX configuration file exists
if [ ! -f "$NGINX_CONF" ]; then
    echo "NGINX configuration file not found at $NGINX_CONF"
    exit 1
fi

# Extract the default environment setting
DEFAULT_ENV=$(grep -oP 'set \$upstream_env \K(blue|green);' "$NGINX_CONF" | tr -d ';')

# Check if the default environment setting was found
if [ -z "$DEFAULT_ENV" ]; then
    echo "Default environment setting not found in $NGINX_CONF"
    exit 1
fi

# Output the default environment
echo "The current default environment is: $DEFAULT_ENV"
