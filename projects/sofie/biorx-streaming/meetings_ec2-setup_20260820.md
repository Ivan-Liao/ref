# 1.0 Enable Binlog
1. Locate MariaDB config file and alter it
```
# typically in C:\Program Files\MariaDB 11.0\data\my.ini
# Installation path on dev VM is C:\SFDevDB\MariaDB 12.0\data

# add this
[mysqld]
server-id=1
log_bin=mariadb-bin
binlog_format=ROW
binlog_row_image=FULL
binlog_expire_logs_seconds=604800
```
2. Stop and restart MariaDB service
```
# Is there risk to restarting? RabbitMQ will be desynced?
# example instructions, paths will need to be changed to match the file structure of the target VM
# change directory to MariaDB bin directory
cd "C:\Program Files\MariaDB 12.0\bin" 

# shutdown mariadb service
.\mariadb-admin.exe -u root -p shutdown 

# Use powershell to start mariadb process
# needs backtick to escape double quotes to handle space in defaults file path
Start-Process -FilePath "C:\Program Files\MariaDB 12.0\bin\mariadbd.exe" -ArgumentList "--defaults-file=`"C:\SFDevDB\MariaDB 12.0\data\my.ini`"" -WindowStyle Hidden
```
3. Validate
   1. Login via command prompt or powershell
   1. `mariadb -u root -p`
   2. `SHOW VARIABLES LIKE 'log_bin';`
   3. `SHOW VARIABLES LIKE 'binlog_format';`
   4. `SHOW VARIABLES LIKE 'binlog_row_image';`
   5. `SHOW VARIABLES LIKE 'binlog_expire_logs_seconds';`


# 2.0 MariaDB debezium user creation
```
# Create service user for Debezium
CREATE USER 'debezium'@'%' IDENTIFIED BY 'StrongPasswordHere';
# In MariaDB 10.5+, REPLICATION CLIENT was renamed BINLOG MONITOR

GRANT REPLICATION SLAVE,
BINLOG MONITOR, 
SELECT,
SHOW DATABASES,
RELOAD,
LOCK TABLES
ON *.* TO 'debezium'@'%';

FLUSH PRIVILEGES;

# Check access by logging in as user Debezium
SHOW MASTER STATUS;
SHOW BINARY LOGS;
```