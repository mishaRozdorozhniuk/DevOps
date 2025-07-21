#!/bin/bash

source /etc/environment

DB_USER=${DB_USER:-test_user}
DB_PASS=${DB_PASS:-test_pass}
DB_NAME=${DB_NAME:-test_db}

APP_USER="app_user"

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

function install_java_sdk() {
    APP_USER="app_user"
    HOME_USER="/home/$APP_USER"
    PROJECT_DIR="/home/$APP_USER/devops_soft/forStep1/PetClinic"
    PROJECT_JAR="$PROJECT_DIR/target"

    echo "Installing java sdk..." 
    apt-get install -y openjdk-11-jdk

    if ! id "$APP_USER" &>/dev/null; then
        useradd -m -s /bin/bash "$APP_USER"
    fi

    if [ ! -d "/home/$APP_USER/devops_soft" ]; then
        sudo -u $APP_USER git clone https://gitlab.com/dan-it/groups/devops_soft.git /home/$APP_USER/devops_soft
    fi

    sudo -u $APP_USER bash -c "
      cd $PROJECT_DIR &&
      chmod +x mvnw &&
      ./mvnw clean package
    "

    if [ $? -eq 0 ]; then
        JAR_FILE=$(find "$PROJECT_JAR" -type f -name "*.jar" | head -n 1)

        if [ -n "$JAR_FILE" ]; then
            cp "$JAR_FILE" "$HOME_USER"

            chown "$APP_USER:$APP_USER" "$HOME_USER/$(basename "$JAR_FILE")"       
        fi
    else
        echo "Bye bye..."
        exit 1
    fi
}

install_java_sdk