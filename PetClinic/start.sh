#!/bin/bash

source /etc/environment

DB_USER=${DB_USER:-test_user}
DB_PASS=${DB_PASS:-test_pass}
DB_NAME=${DB_NAME:-test_db}

function install_my_sql() {
    echo "Updating package list..."
    apt-get update

    echo "Installing MySQL server..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

    echo "Starting MySQL service..."
    service mysql start

    # Настройка bind-address для приватной сети
    echo "Configuring MySQL to accept connections from private network..."
    sed -i "s/^bind-address.*/bind-address = 192.168.56.10/" /etc/mysql/mysql.conf.d/mysqld.cnf

    # Также разрешаем подключения с localhost для безопасности
    sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

    echo "Restarting MySQL service..."
    service mysql restart

    echo "Creating database and user..."

    mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'192.168.56.%' IDENTIFIED BY '${DB_PASS}';
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'192.168.56.%';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

    echo "MySQL installation and configuration completed!"
    echo "Database: ${DB_NAME}"
    echo "User: ${DB_USER}"
    echo "Password: ${DB_PASS}"
    echo "Network: 192.168.56.0/24"
}

install_my_sql
