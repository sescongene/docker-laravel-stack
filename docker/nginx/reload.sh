#!/bin/bash

CONFIG_DIR="/etc/nginx/conf.d"
while inotifywait -e modify,create,delete "$CONFIG_DIR"/*.conf; do
    echo "Change detected in Nginx configuration files. Restarting Nginx..."
    nginx -s reload
done