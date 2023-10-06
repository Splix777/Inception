#!/bin/bash

echo "--Creating and Configuring Wordpress---"

# Move to the wordpress directory.
cd /var/www/html/wordpress

# Download the latest version of wordpress. The --allow-root flag is needed because we are running as root user.
wp core download --path=/var/www/html/wordpress --allow-root

# Create config file wp-config.php with the appropriate database parameters (these are env variables in the .env file).
# The --allow-root flag is needed because we are running as root user.
wp config create --path=/var/www/html/wordpress --allow-root --dbname=$DB_DATABASE --dbhost=$DB_HOST --dbprefix=wp_ --dbuser=$DB_USER_NAME --dbpass=$DB_USER_PASSWORD

# Install wordpress for our website (again, variables are in the .env file)
# The --allow-root flag is needed because we are running as root user.
wp core install --path=/var/www/html/wordpress --allow-root --url=$DOMAIN_NAME --title="$WP_SITE_TITLE" --admin_user=$WP_ADMIN_NAME --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL

# Update all plugins. We need to do this because the wordpress image is not the latest version.
# The --allow-root flag is needed because we are running as root user.
wp plugin update --path=/var/www/html/wordpress --allow-root --all

# Create default user for the website. In this case, we are creating a user with the same credentials as the admin user.
wp user create --path=/var/www/html/wordpress --allow-root $WP_USER_NAME $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD

# Set the owner of the content of our site to www-data user and group
# For security reasons, we want to restrict who has access to these files
# --recursive flag is needed because we want to change the owner of all files and directories inside the uploads directory
chown www-data:www-data /var/www/html/wordpress/wp-content/uploads --recursive

# Make a directory for the php-fpm7.3 socket file.
mkdir -p /run/php/
php-fpm7.3 -F
# Start php-fpm7.3 in the foreground.
# php-fpm7.3 is the FastCGI Process Manager for PHP.
# The -F flag is needed to run php-fpm7.3 in the foreground.
# php-fpm7.3 is needed to run wordpress on our nginx server.
