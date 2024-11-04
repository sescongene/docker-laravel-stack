#!/bin/bash

# Prompt for user input
read -p "Enter the domain name: " domain_name
read -p "Enter the folder name: " folder_name
read -p "Enter the PHP version (e.g., 7.4, 8.0): " php_version

# Define the output configuration file
output_file="./config/nginx/${domain_name}.conf"  # Change this path as needed

# Generate the Nginx configuration
cat <<EOL > "$output_file"
server {
    listen 80;
    index index.php;
    server_name ${domain_name};
    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/acces.log;
    root /var/www/${folder_name}/public;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php${php_version}:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOL

# Check if the domain is already in /etc/hosts
if ! grep -q "${domain_name}" /etc/hosts; then
    # Add the new domain to /etc/hosts
    echo "127.0.0.1 ${domain_name}" | sudo tee -a /etc/hosts > /dev/null
    echo "Added ${domain_name} to /etc/hosts"
else
    echo "${domain_name} is already in /etc/hosts"
fi

# Provide feedback to the user
echo "Nginx configuration file generated at: $output_file"