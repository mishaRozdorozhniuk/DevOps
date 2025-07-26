#!/bin/bash
set -e

source /etc/profile.d/db_env.sh

echo "Installing MySQL..."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

echo "Configuring MySQL to accept remote connections..."
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

echo "Creating database and user..."
mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "✅ MySQL setup complete."
