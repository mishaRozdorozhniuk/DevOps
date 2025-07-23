#!/bin/bash

set -e

source /etc/profile.d/db_env.sh

APP_USER="app_user"

function install_my_sql() {
    echo "Updating package list..."
    apt-get update

    echo "Installing MySQL server..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

    echo "Starting MySQL service..."
    service mysql start

    echo "Configuring MySQL to accept connections from private network..."
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

    echo "✅ MySQL configured with DB: ${DB_NAME}, User: ${DB_USER}"
}

function install_java_sdk() {
    echo "Installing Java SDK and Git..."
    apt-get install -y openjdk-11-jdk git

    if ! id "$APP_USER" &>/dev/null; then
        echo "Creating user $APP_USER"
        useradd -m -s /bin/bash "$APP_USER"
    fi

    HOME_USER="/home/$APP_USER"
    PROJECT_PARENT="$HOME_USER/devops_soft"
    PROJECT_DIR="$PROJECT_PARENT/forStep1/PetClinic"
    PROJECT_JAR="$PROJECT_DIR/target"

    echo "Cleaning existing project dir if exists..."
    rm -rf "$PROJECT_PARENT"
    mkdir -p "$PROJECT_PARENT"
    chown -R "$APP_USER:$APP_USER" "$PROJECT_PARENT"

    echo "Cloning project repo..."
    sudo -u "$APP_USER" git clone https://@gitlab.com/dan-it/groups/devops_soft.git "$PROJECT_PARENT"

    echo "Fixing permissions for project..."
    chown -R "$APP_USER:$APP_USER" "$PROJECT_PARENT"

    echo "Building project..."
    sudo -u "$APP_USER" bash -c "
        cd $PROJECT_DIR &&
        chmod +x mvnw &&
        ./mvnw clean package
    "

    JAR_FILE=$(find "$PROJECT_JAR" -type f -name "*.jar" | head -n 1)

    if [ -n "$JAR_FILE" ]; then
        cp "$JAR_FILE" "$HOME_USER"
        chown "$APP_USER:$APP_USER" "$HOME_USER/$(basename "$JAR_FILE")"

        echo "✅ Starting application..."
        sudo -u "$APP_USER" nohup java -jar "$HOME_USER/$(basename "$JAR_FILE")" > "$HOME_USER/app.log" 2>&1 &
    else
        echo "❌ .jar файл не найден"
        exit 1
    fi
}

install_my_sql
install_java_sdk
