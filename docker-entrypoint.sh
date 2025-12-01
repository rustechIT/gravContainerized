#!/bin/bash
set -e

# Ensure proper permissions on mounted pages volume
chown -R www-data:www-data /var/www/html/grav/user/pages

# Execute the main command
exec "$@"