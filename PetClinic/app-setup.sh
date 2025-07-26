#!/bin/bash
set -e
source /etc/profile.d/db_env.sh

APP_USER="app_user"

function wait_for_db() {
    echo "Waiting for DB..."
    for ((i=1; i<=30; i++)); do
        if mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -e "SHOW DATABASES;" >/dev/null 2>&1; then
            echo "DB is ready!"
            return 0
        fi
        echo "Waiting... ($i/30)"
        sleep 10
    done
    echo "DB timeout"
    exit 1
}

function install_dependencies() {
    apt-get update
    apt-get install -y openjdk-11-jdk git default-mysql-client

    if ! id "$APP_USER" &>/dev/null; then
        useradd -m -s /bin/bash "$APP_USER"
    fi
}

function setup_application() {
    HOME_USER="/home/$APP_USER"
    PROJECT_PARENT="$HOME_USER/devops_soft"
    PROJECT_DIR="$PROJECT_PARENT/forStep1/PetClinic"

    if [ -z "$GIT_USERNAME" ] || [ -z "$GIT_TOKEN" ]; then
        echo "Missing GIT credentials"
        exit 1
    fi

    rm -rf "$PROJECT_PARENT"
    sudo -u "$APP_USER" git clone "https://${GIT_USERNAME}:${GIT_TOKEN}@gitlab.com/dan-it/groups/devops_soft.git" "$PROJECT_PARENT"

    sudo -u "$APP_USER" bash -c "
        cd '$PROJECT_DIR' &&
        chmod +x mvnw &&
        ./mvnw clean package -DskipTests
    "

    JAR_FILE=$(find "$PROJECT_DIR/target" -name "*.jar" | head -n 1)
    [ -z "$JAR_FILE" ] && echo "JAR not found" && exit 1

    cp "$JAR_FILE" "$HOME_USER/"
    chown "$APP_USER:$APP_USER" "$HOME_USER/$(basename "$JAR_FILE")"

    sudo -u "$APP_USER" tee "$HOME_USER/application.properties" > /dev/null <<EOF
spring.datasource.url=jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASS}
spring.jpa.hibernate.ddl-auto=create-drop
server.port=8080
EOF

    echo "Launching app..."
    sudo -u "$APP_USER" bash -c "
        cd '$HOME_USER' &&
        nohup java -jar -Dspring.config.location=file:./application.properties $(basename "$JAR_FILE") > app.log 2>&1 &
    "
    echo "App started. Use: tail -f /home/$APP_USER/app.log"
}

install_dependencies
wait_for_db
setup_application
