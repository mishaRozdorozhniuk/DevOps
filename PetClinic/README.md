# PetClinic Database Setup

## Subtask II - Database Requirements

This project implements all requirements for Subtask II - Database:

### ✅ Completed Requirements:

1. **MySQL Installation**: Uses provisioning script (`start.sh`) to install MySQL and dependencies on DB_VM
2. **Network Configuration**: MySQL configured to accept connections only from Vagrant private network subnet (192.168.56.0/24)
3. **Database User**: Creates non-root user (`DB_USER`) with password (`DB_PASS`) using environment variables
4. **Database Creation**: Creates database (`DB_NAME`) and grants all privileges to `DB_USER`

### 🚀 Quick Start

1. **Set Environment Variables** (choose one method):

   **Method 1 - Export directly:**

   ```bash
   export DB_USER=petclinic_user
   export DB_PASS=petclinic_pass
   export DB_NAME=petclinic_db
   ```

   **Method 2 - Use the script:**

   ```bash
   source env_vars.sh
   ```

2. **Start the VMs:**

   ```bash
   vagrant up
   ```

3. **Verify Database Setup:**
   ```bash
   vagrant ssh DB_VM
   mysql -u petclinic_user -p -h 192.168.56.10 petclinic_db
   ```

### 📁 Files Structure

- `Vagrantfile` - Main configuration with APP_VM and DB_VM
- `start.sh` - MySQL installation and configuration script
- `env_vars.sh` - Environment variables setup script

### 🔧 Configuration Details

- **Database User**: `petclinic_user` (configurable via `DB_USER`)
- **Database Password**: `petclinic_pass` (configurable via `DB_PASS`)
- **Database Name**: `petclinic_db` (configurable via `DB_NAME`)
- **Network**: 192.168.56.0/24 (Vagrant private network)
- **DB_VM IP**: 192.168.56.10

### 🔍 Verification Commands

```bash
# Check if MySQL is running
vagrant ssh DB_VM -c "systemctl status mysql"

# Test database connection
vagrant ssh DB_VM -c "mysql -u petclinic_user -p -e 'SHOW DATABASES;'"

# Check MySQL configuration
vagrant ssh DB_VM -c "grep bind-address /etc/mysql/mysql.conf.d/mysqld.cnf"
```
