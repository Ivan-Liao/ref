- [MariaDB setup](#mariadb-setup)
- [MariaDB debezium user creation](#mariadb-debezium-user-creation)


# MariaDB setup
1. Login via command prompt
   1. `mariadb -u root -p`
2. Check binlog status
   1. `SHOW VARIABLES LIKE 'log_bin';`
3. Locate MariaDB config file and alter it
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
4. Stop and restart MariaDB service
```
# change directory to MariaDB bin directory
cd "C:\Program Files\MariaDB 12.0\bin" 

.\mariadb-admin.exe -u root -p shutdown 

# need backtick to escape double quotes to handle space in defaults file path
Start-Process -FilePath "C:\Program Files\MariaDB 12.0\bin\mariadbd.exe" -ArgumentList "--defaults-file=C:\Program Files\MariaDB 12.0\data\my.ini" -WindowStyle Hidden


# to permanently install MariaDB as a service
cd "C:\Program Files\MariaDB\bin"
.\mariadb-install-db.exe --service=MariaDB --password=YourRootPassword
```

# MariaDB debezium user creation
```
# Optional hostname if debezium will run from a known host address
CREATE USER 'debezium'@'%' IDENTIFIED BY 'StrongPasswordHere';

GRANT REPLICATION SLAVE,
REPLICATION CLIENT,
SELECT,
RELOAD,
LOCK TABLES
ON *.* TO 'debezium'@'%';

FLUSH PRIVILEGES;

# Check access by logging in as user Debezium
SHOW MASTER STATUS;
SHOW BINARY LOGS;
```