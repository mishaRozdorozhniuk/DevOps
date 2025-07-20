#!/bin/bash

DB_HOST=${DB_HOST:-192.168.56.10}
DB_USER=${DB_USER:-test_user}
DB_PASS=${DB_PASS:-test_pass}

echo "Updating package list..."
apt-get update

echo "Installing MySQL client..."
apt-get install -y default-mysql-client

echo "Trying to connect to the database at $DB_HOST..."
mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -e "SHOW DATABASES;"
