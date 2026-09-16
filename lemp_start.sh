#!/bin/bash
# Start LEMP stack services.
service mysql          start 2>/dev/null
service php8.3-fpm  start 2>/dev/null
service nginx          start 2>/dev/null
echo "LEMP stack services started."
