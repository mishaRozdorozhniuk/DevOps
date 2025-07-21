#!/bin/bash

DB_HOST=${DB_HOST:-192.168.56.10}
DB_USER=${DB_USER:-test_user}
DB_PASS=${DB_PASS:-test_pass}

echo "Updating package list..."
apt-get update

echo "Installing MySQL client..."
apt-get install -y default-mysql-client

echo "Trying to connect to the database at $DB_HOST..."

MAX_RETRIES=10
RETRY_DELAY=5

for ((i=1; i<=MAX_RETRIES; i++)); do
  if mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -e "SHOW DATABASES;"; then
    echo "✅ Connection successful!"
    exit 0
  else
    echo "❌ Connection failed. Retry $i/$MAX_RETRIES..."
    sleep $RETRY_DELAY
  fi
done

echo "🚫 Failed to connect to the database after $MAX_RETRIES attempts."
exit 1
