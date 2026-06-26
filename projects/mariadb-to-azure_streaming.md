- [MariaDB binlog setup](#mariadb-binlog-setup)
- [MariaDB debezium user creation](#mariadb-debezium-user-creation)
- [Kafka installation](#kafka-installation)
- [Kafka startup](#kafka-startup)
- [Debezium configuration](#debezium-configuration)
- [Azure Events Hub to Delta Lake](#azure-events-hub-to-delta-lake)
- [Connect Delta Lake to Fabric](#connect-delta-lake-to-fabric)
- [Buildout Fabric streaming pipeline](#buildout-fabric-streaming-pipeline)
- [Connect Fabric to PowerBI](#connect-fabric-to-powerbi)
- [MariaDB SQL references](#mariadb-sql-references)


# MariaDB binlog setup
1. Login via command prompt or powershell
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
Start-Process -FilePath "C:\Program Files\MariaDB 12.0\bin\mariadbd.exe" -ArgumentList "--defaults-file=`"C:\SFDevDB\MariaDB 12.0\data\my.ini`"" -WindowStyle Hidden


# to permanently install MariaDB as a service
cd "C:\Program Files\MariaDB\bin"
.\mariadb-install-db.exe --service=MariaDB --password=YourRootPassword
```

# MariaDB debezium user creation
```
# Optional hostname if debezium will run from a known host address
CREATE USER 'debezium'@'%' IDENTIFIED BY 'StrongPasswordHere';
# In MariaDB 10.5+, REPLICATION CLIENT was renamed BINLOG MONITOR

GRANT REPLICATION SLAVE,
BINLOG MONITOR, 
SELECT,
RELOAD,
LOCK TABLES
ON *.* TO 'debezium'@'%';

FLUSH PRIVILEGES;

# Check access by logging in as user Debezium
SHOW MASTER STATUS;
SHOW BINARY LOGS;
```

# Kafka installation
1. May need to install the latest Java SDK
2. Add kafka/bin directory to Windows Env variables
   1. Settings > System > Optional Settings > View all > WMIC (Check box)
3. Kafka
   1. Kafka binary from kafka.apache.org (note Kafka 4.x and above no longer utilize zookeeper)
   2. Configure config\server.properties
      1. `log.dirs=C:/kafka/kafka-logs`
   3. Cluster ID and Format Storage
```
cd C:\kafka
.\bin\windows\kafka-storage.bat random-uuid
# Format log directory using output UUID
.\bin\windows\kafka-storage.bat format -t cldahqo1SRyavcJGsgYCcQ -c .\config\server.properties
```

# Kafka startup
1. Launch the broker
```
.\bin\windows\kafka-server-start.bat .\config\server.properties --standalone
# Note this cmd window will need to be kept open
```
2. Debezium MariaDB Connector plugin
   1. https://debezium.io/documentation/reference/stable/connectors/mariadb.html
   2. Place extracted folder in C:\kafka\plugins
3. Kafka Connect
```
# Open C:\kafka\config\connect-standalone.properties
# Point configuration to running broker
bootstrap.servers=localhost:9092
# Define plugin path
plugin.path=C:/kafka/plugins
# New command prompt and launch standalone worker
.\bin\windows\connect-standalone.bat .\config\connect-standalone.properties .\config\connect-file-sink.properties
# Verify plugin installation
http://localhost:8083/connector-plugins
```
```
# Other success log text

Kafka Connect started
REST resources initialized; server is started and ready to handle requests
Started http_8083 ... {0.0.0.0:8083} indicating the REST API is listening on port 8083
Created connector local-file-sink
WorkerSinkTask{id=local-file-sink-0} Sink task finished initialization and start
Successfully joined group and Successfully synced group showing the connector is actively consuming Kafka messages
```

#  Debezium configuration
1. JSON connector config file mariadb-connector.json
```
{
  "name": "mariadb-cdc",
  "config": {
    "connector.class": "io.debezium.connector.mariadb.MariaDbConnector",

    "database.hostname": "localhost",
    "database.port": "3306",

    "database.user": "debezium",
    "database.password": "YOUR_DEBEZIUM_USER_PASSWORD_HERE",

    "database.server.id": "5401",

    "topic.prefix": "biorx",

    "database.include.list": "master",
    
    "table.include.list": "master.ordered,master.reasoncode",

    "schema.history.internal.kafka.bootstrap.servers": "localhost:9092",

    "schema.history.internal.kafka.topic": "schema-history.master",

    "snapshot.mode": "initial",

    "include.schema.changes": "true"
  }
}
# optional optimizations
# note optional     "column.include.list": "YOUR_FULLY_QUALIFIED_TABLE_NAME_HERE"
# note optional properties for lean events
# key.converter.schemas.enable = false
# value.converter.schemas.enable = false
```
2. Create windows path for offset
```
# Depends on which worker file but for standalone
# kafka/config/connect-standalone.properties
# look for line offset.storage.file.filename=C:/kafka/connect-data/connect.offsets
```
3. Register Connector
```
# powershell
Invoke-RestMethod `
    -Method Post `
    -Uri http://localhost:8083/connectors `
    -ContentType "application/json" `
    -InFile C:\Kafka\mariadb-connector.json

# cmd prompt alternative
curl -X POST ^
  -H "Content-Type: application/json" ^
  --data @C:\Kafka\mariadb-connector.json ^
  http://localhost:8083/connectors
```
3. Check connector status
   1. `curl http://localhost:8083/connectors/mariadb-cdc/status`
4. Verify CDC event delivery
```
# list topics
.\bin\windows\kafka-topics.bat ^
  --bootstrap-server localhost:9092 ^
  --list

# consume events
.\bin\windows\kafka-console-consumer.bat ^
  --bootstrap-server localhost:9092 ^
  --topic biorx.master.reasoncode ^
  --from-beginning

# keep consume event window open

# manual sql statments in MariaDB
INSERT INTO customers
VALUES (1,'John Doe','john@example.com');

DELETE FROM customers
where col = "YOUR_VALUE"
```
5. Azure Events Hub setup
   1. 
6. Connect Debezium to Azure Event Hubs
   1. https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-kafka-connect-debezium

# Azure Events Hub to Delta Lake

# Connect Delta Lake to Fabric

# Buildout Fabric streaming pipeline

# Connect Fabric to PowerBI 

# MariaDB SQL references
```
# list tables
SHOW TABLES;
SELECT * FROM reason LIMIT 5;
SELECT * FROM reasoncode where DeletedDT is null LIMIT 5;
INSERT into reasoncode (ReasonCodeID, ReasonCodeGUID, Action, Code, Description, CreatedDT, CreatedByID, DeletedDT, DeletedByID, Synced, Deleted, CancelledOrder) VALUES (99955,'TESTTEST-D2A6-45EF-A592-ABE3E4CE6112', 0, 999, 'Test Reason', '2026-06-24 12:45:00', 999, NULL, NULL, 1, 0, 1);
SELECT * FROM reasoncode where ReasonCodeID = 99955;
DELETE FROM reasoncode where ReasonCodeID = 99955;
```