#!/bin/bash
# Setup and start nginx with DivinG_BAZ configuration

echo "Setting up nginx configuration..."

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NGINX_CONF="$SCRIPT_DIR/nginx-port3000.conf"

# Copy the nginx config to the system location
# This requires sudo
if [ -f "$NGINX_CONF" ]; then
    echo "Found nginx configuration at: $NGINX_CONF"
    echo "To use this configuration, run:"
    echo ""
    echo "  sudo cp $NGINX_CONF /usr/local/etc/nginx/servers/diving.conf"
    echo "  sudo brew services restart nginx"
    echo ""
    echo "Or manually add to /usr/local/etc/nginx/nginx.conf:"
    echo "  include /usr/local/etc/nginx/servers/*.conf;"
else
    echo "Error: nginx configuration not found at $NGINX_CONF"
fi
