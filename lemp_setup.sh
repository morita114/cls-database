#!/bin/bash
# =============================================================================
#  lemp_setup.sh
#  Nginx + PHP + MySQL setup script for WSL (Ubuntu 24.04)
# =============================================================================

set -euo pipefail

# Console color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Environment variables
PHP_VERSION="8.3"
MYSQL_ROOT_PASSWORD="password"
DB_NAME="testdb"            # MySQL test database name
DB_USER="testuser"          # MySQL test user name
DB_PASSWORD="testpassword"  # Password for the MySQL test user
# SERVER_NAME="localhost"
WEB_ROOT="/var/www/html"

# Helper functions
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }
section() { echo -e "\n${BOLD}${CYAN}=== $* ===${NC}"; }

# root execution check
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run with sudo privileges.\n ex) sudo bash $0"
    fi
}

# Check WSL environment
check_wsl() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        info "Detected WSL environment."
    else
        warn "This is not a WSL environment. Continue anyway? [y/N]"
        read -r ans
        [[ "$ans" =~ ^[Yy]$ ]] || exit 0
    fi
}

# Package update
update_packages() {
    section "Updating packages."
    apt-get update -y
    apt-get upgrade -y
    success "Packages updated successfully."
}

# Nginx installation
install_nginx() {
    section "Nginx installation"
    apt-get install -y nginx

    # Check if nginx is running.
    if systemctl is-active --quiet nginx 2>/dev/null; then
        success "Nginx is already running."
    else
        # If systemctl is not available, try starting nginx directly
        service nginx start 2>/dev/null || nginx 2>/dev/null || true
    fi
    nginx -v
    success "Nginx installation completed successfully."
}

# PHP installation
install_php() {
    section "PHP ${PHP_VERSION} installation"

    # apt-get install -y \
    #     "php${PHP_VERSION}" \
    #     "php${PHP_VERSION}-fpm" \
    #     "php${PHP_VERSION}-cli" \
    #     "php${PHP_VERSION}-mysql" \
    #     "php${PHP_VERSION}-curl" \
    #     "php${PHP_VERSION}-gd" \
    #     "php${PHP_VERSION}-mbstring" \
    #     "php${PHP_VERSION}-xml" \
    #     "php${PHP_VERSION}-zip" \
    #     "php${PHP_VERSION}-bcmath" \
    #     "php${PHP_VERSION}-intl" \
    #     "php${PHP_VERSION}-opcache" \
    #     "php${PHP_VERSION}-redis" \
    #     "php${PHP_VERSION}-imagick" 2>/dev/null || \
    # apt-get install -y \
    #     "php${PHP_VERSION}-fpm" \
    #     "php${PHP_VERSION}-cli" \
    #     "php${PHP_VERSION}-mysql" \
    #     "php${PHP_VERSION}-curl" \
    #     "php${PHP_VERSION}-gd" \
    #     "php${PHP_VERSION}-mbstring" \
    #     "php${PHP_VERSION}-xml" \
    #     "php${PHP_VERSION}-zip" \
    #     "php${PHP_VERSION}-bcmath" \
    #     "php${PHP_VERSION}-opcache"
    apt-get install -y \
        "php${PHP_VERSION}" \
        "php${PHP_VERSION}-fpm" \
        "php${PHP_VERSION}-cli" \
        "php${PHP_VERSION}-mysql" \
        "php${PHP_VERSION}-curl" \
        "php${PHP_VERSION}-mbstring" 2>/dev/null || \
    apt-get install -y \
        "php${PHP_VERSION}-fpm" \
        "php${PHP_VERSION}-cli" \
        "php${PHP_VERSION}-mysql" \
        "php${PHP_VERSION}-curl" \
        "php${PHP_VERSION}-mbstring"

    php -v
    success "PHP ${PHP_VERSION} installation completed successfully."
}

# MySQL installation
install_mysql() {
    section "MySQL installation"

    # Skip interactive prompts
    debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}"

    apt-get install -y mysql-server mysql-client


    echo "Try to start service "
    # service mysql stop 2>/dev/null || true
    echo "Service stopped"
    # Start MySQL service
    service mysql start 2>/dev/null || true

    # mkdir /var/run/mysqld 2>/dev/null || true
    # chown mysql:mysql /var/run/mysqld 2>/dev/null || true
    # mysqld_safe --skip-grant-tables & 2>/dev/null || true

    echo "Service started"

    # Configure root password and authentication method
    mysql -u root -ppassword <<-EOF
        ALTER USER 'root'@'localhost'
            IDENTIFIED WITH caching_sha2_password BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOF

    success "MySQL installation completed successfully."
}

# Test MySQL database connection
setup_database() {
    section "Create database and user"

    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOF
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`
            CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost'
            IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
        FLUSH PRIVILEGES;
EOF

    success "Create database \"${DB_NAME}\" and user \"${DB_USER}\"."
}


# Setup web root directory and test scripts
setup_webroot() {
    section "Creating web root directory and test scripts"

    mkdir -p "${WEB_ROOT}"
    chown -R www-data:www-data "${WEB_ROOT}"
    chmod -R 755 "${WEB_ROOT}"

    # phpinfo() for test
    cat > "${WEB_ROOT}/index.php" <<'PHPEOF'
<?php
phpinfo();
PHPEOF

    # Test MySQL DB connection.
    cat > "${WEB_ROOT}/db_test.php" <<PHPEOF
<?php
\$host = '127.0.0.1';
\$db   = '${DB_NAME}';
\$user = '${DB_USER}';
\$pass = '${DB_PASSWORD}';

try {
    \$pdo = new PDO("mysql:host=\$host;dbname=\$db;charset=utf8mb4", \$user, \$pass);
    echo '<p style="color:green;font-size:1.5em">Successfully connected to MySQL.</p>';
} catch (PDOException \$e) {
    echo '<p style="color:red;font-size:1.5em">Failed to connect to MySQL: ' . \$e->getMessage() . '</p>';
}
PHPEOF

    chown www-data:www-data "${WEB_ROOT}/index.php" "${WEB_ROOT}/db_test.php"
    success "Made web root directory and test scripts for 「${WEB_ROOT}」."
}


# Configure Nginx virtual host settings
configure_nginx() {
    section "Nginx virtual host settings"

    local FPM_SOCK="/var/run/php/php${PHP_VERSION}-fpm.sock"

    cat > "/etc/nginx/conf.d/default.conf" <<NGINXEOF
server {
    listen 80;
    server_name localhost;
    root ${WEB_ROOT};
    index index.php index.html index.htm;

    charset utf-8;
    client_max_body_size 50M;

    location ~ \.php\$ {
        if (!-f \$document_root\$fastcgi_script_name) {
            return 404;
        }
        fastcgi_pass            unix:${FPM_SOCK};
        fastcgi_index           index.php;
        fastcgi_param           SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include                 fastcgi_params;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }
}
NGINXEOF

    # # Symbolic link to sites-enabled
    # ln -sf "${VHOST_FILE}" "/etc/nginx/sites-enabled/${SERVER_NAME}"

    # Clear default config
    rm -f /etc/nginx/sites-enabled/default

    # test
    nginx -t
    service nginx reload 2>/dev/null || nginx -s reload 2>/dev/null || true

    success "Nginx virtual host setting completed."
}
# http://localhost/info.php
# http://localhost/hello.html


# Configure PHP-FPM settings
configure_php_fpm() {
    section "Configure PHP-FPM"

    local PHP_INI="/etc/php/${PHP_VERSION}/fpm/php.ini"

    # Apply recommended settings
    sed -i 's/^upload_max_filesize.*/upload_max_filesize = 50M/'   "${PHP_INI}"
    sed -i 's/^post_max_size.*/post_max_size = 50M/'               "${PHP_INI}"
    sed -i 's/^memory_limit.*/memory_limit = 256M/'                "${PHP_INI}"
    sed -i 's/^max_execution_time.*/max_execution_time = 300/'     "${PHP_INI}"
    sed -i 's/^;date.timezone.*/date.timezone = Asia\/Tokyo/'      "${PHP_INI}"

    # Start PHP-FPM
    service "php${PHP_VERSION}-fpm" start 2>/dev/null || true

    success "Configured PHP-FPM."
}


generate_lemp_start() {
    section "Generate LEMP stack start script"

    local AUTOSTART="./lemp_start.sh"

    cat > "${AUTOSTART}" <<STARTEOF
#!/bin/bash
# Start LEMP stack services.
service mysql          start 2>/dev/null
service php${PHP_VERSION}-fpm  start 2>/dev/null
service nginx          start 2>/dev/null
echo "LEMP stack services started."
STARTEOF

    success "Generated LEMP stack start script at 「${AUTOSTART}」."
}

main() {
    check_root
    check_wsl
    update_packages
    install_nginx
    install_php
    install_mysql
    setup_database
    setup_webroot
    configure_nginx
    configure_php_fpm
    generate_lemp_start
}

main "$@"
