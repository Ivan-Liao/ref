- [MariaDB binlog setup](#mariadb-binlog-setup)
- [MariaDB debezium user creation](#mariadb-debezium-user-creation)
- [Kafka installation](#kafka-installation)
- [Kafka startup](#kafka-startup)
- [Debezium configuration](#debezium-configuration)
- [powershell](#powershell)
- [cmd prompt alternative](#cmd-prompt-alternative)
- [list topics](#list-topics)
- [consume events](#consume-events)
- [manual sql statments in MariaDB](#manual-sql-statments-in-mariadb)
- [Update configurations to point to Eventstream custom endpoint](#update-configurations-to-point-to-eventstream-custom-endpoint)
- [Use Fabric created topic on Fabric Eventstream](#use-fabric-created-topic-on-fabric-eventstream)
- [Configure VNET settings](#configure-vnet-settings)
- [Eventstream to Eventhouse](#eventstream-to-eventhouse)
- [Eventhouse KQL Update Policy](#eventhouse-kql-update-policy)
- [Eventhouse Materialized View](#eventhouse-materialized-view)
- [Eventhouse Real time dashboard](#eventhouse-real-time-dashboard)
- [Connect Fabric to PowerBI](#connect-fabric-to-powerbi)
- [references](#references)
  - [MariaDB corruption recover](#mariadb-corruption-recover)
  - [Capturing a processing timestamp in KQL](#capturing-a-processing-timestamp-in-kql)
  - [MariaDB SQL references](#mariadb-sql-references)
    - [list tables](#list-tables)
  - [example Debezium json event](#example-debezium-json-event)
  - [mariadb-connector.json versions](#mariadb-connectorjson-versions)


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
# for log messages
`& "C:\Program Files\MariaDB 12.0\bin\mariadbd.exe" --defaults-file="C:\SFDevDB\MariaDB 12.0\data\my.ini" --console`


# (Optional) to permanently install MariaDB as a service
cd "C:\Program Files\MariaDB\bin"
.\mariadb-install-db.exe --service=MariaDB --password=YourRootPassword
```

# MariaDB debezium user creation
```
# Create service user for Debezium
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
2. Settings > System > Optional Settings > View all > WMIC (Check box)
3. Kafka
   1. Download Kafka binary from kafka.apache.org (note Kafka 4.x and above no longer utilize zookeeper)
   2. Add kafka/bin directory to Windows Env variables
   3. Configure config\server.properties
      1. `log.dirs=C:/kafka/kafka-logs`
      2. `auto.create.topics.enable=true`
   4. Cluster ID and Format Storage
   5. Set Kafka logging explicitly
      1. `set KAFKA_LOG4J_OPTS=-Dlog4j2.configurationFile=file:C:/kafka/config/log4j2.yaml`
```
cd C:\kafka
\bin\windows\kafka-storage.bat random-uuid
# Format log directory using output UUID
.\bin\windows\kafka-storage.bat format -t i_Yk4I8RQCOyhZIe_0pucA -c .\config\server.properties --standalone
```

# Kafka startup
1. Launch the broker
```
.\bin\windows\kafka-server-start.bat .\config\server.properties
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
# Create windows path for offset
offset.storage.file.filename=C:/kafka/connect-data/connect.offsets
# New command prompt and launch standalone worker
.\bin\windows\connect-standalone.bat .\config\connect-standalone.properties .\config\connect-file-sink.properties
# override policy
connector.client.config.override.policy=All
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
```
1. Register Connector
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

# manual sql statments in MariaDB
INSERT into reasoncode (ReasonCodeID, ReasonCodeGUID, Action, Code, Description, CreatedDT, CreatedByID, DeletedDT, DeletedByID, Synced, Deleted, CancelledOrder) VALUES (99955,'TESTTEST-D2A6-45EF-A592-ABE3E4CE6112', 0, 999, 'Test Reason', '2026-06-24 12:45:00', 999, NULL, NULL, 1, 0, 1);
SELECT * FROM reasoncode where ReasonCodeID = 99955;
DELETE FROM reasoncode where ReasonCodeID = 99955;

```
1. Azure Events Hub setup
   1. 
2. Connect Debezium to Azure Event Hubs
   1. https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-kafka-connect-debezium

# Azure Fabric Eventstream
1. Create custom stream endpoint
   1.  My workspace > New Item > Eventstream > Use custom endpoint
2. Reconfigure Kafka connect properties file along with security
```
# Update configurations to point to Eventstream custom endpoint
1. In connect-standalone.properties
```
# Bootstrap server retrieved from Fabric (Sources > Protocol: Kafka > SAS Key Authentication)
bootstrap.servers=esehbn9kd0zwt2ixox3m9p.servicebus.windows.net:9093

# Security settings required by Fabric's Kafka layer
security.protocol=SASL_SSL
sasl.mechanism=PLAIN

# The username is literally '$ConnectionString'. Do not replace this with a variable name.
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
  username="$ConnectionString" \
  password="YOUR_CONNECTION_STRING_PRIMARY_KEY_FROM_FABRIC";
```
2. mariadb-connector.json additional updates needs bootstrap.servers updated as well
```
{
  "name": "mariadb-cdc-v6",
  "config": {
    "connector.class": "io.debezium.connector.mariadb.MariaDbConnector",
    "database.hostname": "localhost",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "toodles-zoO-SquirreL-19284",
    "database.server.id": "5401",
    "topic.prefix": "biorx3",
    "database.include.list": "master",
    "table.include.list": "master.reasoncode",
    "schema.history.internal.kafka.topic": "esehbn18tmfo040bvonhn8_eh",
    "schema.history.internal.kafka.bootstrap.servers": "esehbn18tmfo040bvonhn8.servicebus.windows.net:9093",
    "schema.history.internal.producer.security.protocol": "SASL_SSL",
    "schema.history.internal.producer.sasl.mechanism": "PLAIN",
    "schema.history.internal.producer.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"",
    "schema.history.internal.consumer.security.protocol": "SASL_SSL",
    "schema.history.internal.consumer.sasl.mechanism": "PLAIN",
    "schema.history.internal.consumer.sasl.jaas.config":  "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"",
    "producer.override.security.protocol": "SASL_SSL",
    "producer.override.sasl.mechanism": "PLAIN",
    "producer.override.sasl.jaas.config":  "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"",
    "signal.enabled.channels": "",    
    "snapshot.mode": "no_data",
    "transforms": "route",
    "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.route.regex": "biorx3\\.master\\.(.*)",
    "transforms.route.replacement": "esehbn18tmfo040bvonhn8_eh",
    "include.schema.changes": "true"
  }
}
```

# Use Fabric created topic on Fabric Eventstream



# Configure VNET settings
   1. Add outbound security rule for IP associated with the VM sfdevdesktop
```
Source: Specific private IP of sfdevdesktop (172.17.0.4).
Source Port Ranges: *
Destination: AzureCloud
Destination Port Ranges: 9093
Protocol: TCP
Action: Allow

# test connectivity
# linux
nc -zv esehbn9kd0zwt2ixox3m9p.servicebus.windows.net:9093 9093
# windows
Test-NetConnection -ComputerName esehbn9kd0zwt2ixox3m9p.servicebus.windows.net -Port 9093
telnet esehbn9kd0zwt2ixox3m9p.servicebus.windows.net:9093 9093
```

# Eventstream to Eventhouse

# Eventhouse KQL Update Policy
1. CDC JSON stream into a raw Eventhouse table
2. Flattening function
```
.create function with (docstring = 'Extracts after object and flattens CDC payload', folder = 'Transformations') Flatten_ReasonCodes() {
    Raw_ReasonCodes
    | project 
        ReasonCodeID = toint(payload.after.ReasonCodeID),
        ReasonCodeGUID = tostring(payload.after.ReasonCodeGUID),
        Action = toint(payload.after.Action),
        Code = tostring(payload.after.Code),
        Description = tostring(payload.after.Description),
        CreatedDT = todatetime(payload.after.CreatedDT),
        CreatedByID = toint(payload.after.CreatedByID),
        Synced = toint(payload.after.Synced),
        Deleted = toint(payload.after.Deleted),
        CancelledOrder = toint(payload.after.CancelledOrder),
        ChangeTimestamp = todatetime(payload.payload.ts_ms)
}
```
3. Define Update Policy
```
// 1. Create the target table
.create table Current_ReasonCodes (
    ReasonCodeID: int,
    ReasonCodeGUID: string,
    Action: int,
    Code: string,
    Description: string,
    CreatedDT: datetime,
    CreatedByID: int,
    Synced: int,
    Deleted: int,
    CancelledOrder: int,
    ChangeTimestamp: datetime
)

// 2. Apply the update policy
.alter table Current_ReasonCodes policy update @'[{"IsEnabled": true, "Source": "Raw_ReasonCodes", "Query": "Flatten_ReasonCodes()", "IsTransactional": false}]'
```
5. Materialized view to instantly query current true state
```
.create materialized-view MV_Current_ReasonCodes on table Current_ReasonCodes {
    Current_ReasonCodes
    | summarize arg_max(ChangeTimestamp, *) by ReasonCodeID
    | where Deleted == 0
}
```


# Eventhouse Materialized View

# Eventhouse Real time dashboard


# Connect Fabric to PowerBI 




# references
## MariaDB corruption recover
```
Remove-Item "C:\SFDevDB\MariaDB 12.0\data\aria_log.*" -Force

$ariaChk = "C:\Program Files\MariaDB 12.0\bin\aria_chk.exe"
$dataDir = "C:\SFDevDB\MariaDB 12.0\data"

Get-ChildItem -Path $dataDir -Filter "*.MAI" -Recurse | ForEach-Object {
    Write-Host "Repairing: $($_.FullName)" -ForegroundColor Cyan
    & $ariaChk -r $_.FullName
}
```
## Capturing a processing timestamp in KQL
```
// 1. Raw landing table to accept untyped Custom Endpoint events
.create table RawKafkaEvents (Payload: string)

// 2. Final target table that includes the new LandedTimestamp column
.create table CleanKafkaEvents (
    Payload: string, 
    LandedTimestamp: datetime
)


.create-or-alter function AppendLandedTimestamp() {
    RawKafkaEvents
    | extend LandedTimestamp = ingestion_time()
    | project Payload, LandedTimestamp
}

.alter table CleanKafkaEvents policy update 
[{
    "IsEnabled": true,
    "Source": "RawKafkaEvents",
    "Query": "AppendLandedTimestamp()",
    "IsTransactional": false,
    "PropagateIngestionProperties": false
}]
```

## MariaDB SQL references

### list tables
```
SHOW TABLES;
SELECT * FROM reason LIMIT 5;
SELECT * FROM reasoncode where DeletedDT is null LIMIT 5;
```
## example Debezium json event
1. deletion
```
{"schema":{"type":"struct","fields":[{"type":"struct","fields":[{"type":"int32","optional":false,"field":"ReasonCodeID"},{"type":"string","optional":true,"field":"ReasonCodeGUID"},{"type":"int32","optional":true,"field":"Action"},{"type":"string","optional":true,"field":"Code"},{"type":"string","optional":true,"field":"Description"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"CreatedDT"},{"type":"int32","optional":true,"field":"CreatedByID"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"DeletedDT"},{"type":"int32","optional":true,"field":"DeletedByID"},{"type":"int16","optional":true,"default":0,"field":"Synced"},{"type":"int16","optional":true,"default":0,"field":"Deleted"},{"type":"int16","optional":true,"default":0,"field":"CancelledOrder"}],"optional":true,"name":"biorx.master.reasoncode.Value","field":"before"},{"type":"struct","fields":[{"type":"int32","optional":false,"field":"ReasonCodeID"},{"type":"string","optional":true,"field":"ReasonCodeGUID"},{"type":"int32","optional":true,"field":"Action"},{"type":"string","optional":true,"field":"Code"},{"type":"string","optional":true,"field":"Description"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"CreatedDT"},{"type":"int32","optional":true,"field":"CreatedByID"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"DeletedDT"},{"type":"int32","optional":true,"field":"DeletedByID"},{"type":"int16","optional":true,"default":0,"field":"Synced"},{"type":"int16","optional":true,"default":0,"field":"Deleted"},{"type":"int16","optional":true,"default":0,"field":"CancelledOrder"}],"optional":true,"name":"biorx.master.reasoncode.Value","field":"after"},{"type":"struct","fields":[{"type":"string","optional":false,"field":"version"},{"type":"string","optional":false,"field":"connector"},{"type":"string","optional":false,"field":"name"},{"type":"int64","optional":false,"field":"ts_ms"},{"type":"string","optional":true,"name":"io.debezium.data.Enum","version":1,"parameters":{"allowed":"true,first,first_in_data_collection,last_in_data_collection,last,false,incremental"},"default":"false","field":"snapshot"},{"type":"string","optional":false,"field":"db"},{"type":"string","optional":true,"field":"sequence"},{"type":"int64","optional":true,"field":"ts_us"},{"type":"int64","optional":true,"field":"ts_ns"},{"type":"string","optional":true,"field":"table"},{"type":"int64","optional":false,"field":"server_id"},{"type":"string","optional":true,"field":"gtid"},{"type":"string","optional":false,"field":"file"},{"type":"int64","optional":false,"field":"pos"},{"type":"int32","optional":false,"field":"row"},{"type":"int64","optional":true,"field":"thread"},{"type":"string","optional":true,"field":"query"}],"optional":false,"name":"io.debezium.connector.mariadb.Source","version":1,"field":"source"},{"type":"struct","fields":[{"type":"string","optional":false,"field":"id"},{"type":"int64","optional":false,"field":"total_order"},{"type":"int64","optional":false,"field":"data_collection_order"}],"optional":true,"name":"event.block","version":1,"field":"transaction"},{"type":"string","optional":false,"field":"op"},{"type":"int64","optional":true,"field":"ts_ms"},{"type":"int64","optional":true,"field":"ts_us"},{"type":"int64","optional":true,"field":"ts_ns"}],"optional":false,"name":"biorx.master.reasoncode.Envelope","version":2},"payload":{"before":{"ReasonCodeID":99955,"ReasonCodeGUID":"TESTTEST-D2A6-45EF-A592-ABE3323f6212","Action":0,"Code":"999","Description":"Test Reason","CreatedDT":1782305100000,"CreatedByID":999,"DeletedDT":null,"DeletedByID":null,"Synced":1,"Deleted":0,"CancelledOrder":1},"after":null,"source":{"version":"3.5.2.Final","connector":"mariadb","name":"biorx","ts_ms":1782327979000,"snapshot":"false","db":"master","sequence":null,"ts_us":1782327979000000,"ts_ns":1782327979000000000,"table":"reasoncode","server_id":1,"gtid":"0-1-37","file":"mariadb-bin.000002","pos":16043,"row":0,"thread":null,"query":null},"transaction":null,"op":"d","ts_ms":1782327979817,"ts_us":1782327979817895,"ts_ns":1782327979817895400}}
```
2. creation
```
{"schema":{"type":"struct","fields":[{"type":"struct","fields":[{"type":"int32","optional":false,"field":"ReasonCodeID"},{"type":"string","optional":true,"field":"ReasonCodeGUID"},{"type":"int32","optional":true,"field":"Action"},{"type":"string","optional":true,"field":"Code"},{"type":"string","optional":true,"field":"Description"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"CreatedDT"},{"type":"int32","optional":true,"field":"CreatedByID"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"DeletedDT"},{"type":"int32","optional":true,"field":"DeletedByID"},{"type":"int16","optional":true,"default":0,"field":"Synced"},{"type":"int16","optional":true,"default":0,"field":"Deleted"},{"type":"int16","optional":true,"default":0,"field":"CancelledOrder"}],"optional":true,"name":"biorx.master.reasoncode.Value","field":"before"},{"type":"struct","fields":[{"type":"int32","optional":false,"field":"ReasonCodeID"},{"type":"string","optional":true,"field":"ReasonCodeGUID"},{"type":"int32","optional":true,"field":"Action"},{"type":"string","optional":true,"field":"Code"},{"type":"string","optional":true,"field":"Description"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"CreatedDT"},{"type":"int32","optional":true,"field":"CreatedByID"},{"type":"int64","optional":true,"name":"io.debezium.time.Timestamp","version":1,"field":"DeletedDT"},{"type":"int32","optional":true,"field":"DeletedByID"},{"type":"int16","optional":true,"default":0,"field":"Synced"},{"type":"int16","optional":true,"default":0,"field":"Deleted"},{"type":"int16","optional":true,"default":0,"field":"CancelledOrder"}],"optional":true,"name":"biorx.master.reasoncode.Value","field":"after"},{"type":"struct","fields":[{"type":"string","optional":false,"field":"version"},{"type":"string","optional":false,"field":"connector"},{"type":"string","optional":false,"field":"name"},{"type":"int64","optional":false,"field":"ts_ms"},{"type":"string","optional":true,"name":"io.debezium.data.Enum","version":1,"parameters":{"allowed":"true,first,first_in_data_collection,last_in_data_collection,last,false,incremental"},"default":"false","field":"snapshot"},{"type":"string","optional":false,"field":"db"},{"type":"string","optional":true,"field":"sequence"},{"type":"int64","optional":true,"field":"ts_us"},{"type":"int64","optional":true,"field":"ts_ns"},{"type":"string","optional":true,"field":"table"},{"type":"int64","optional":false,"field":"server_id"},{"type":"string","optional":true,"field":"gtid"},{"type":"string","optional":false,"field":"file"},{"type":"int64","optional":false,"field":"pos"},{"type":"int32","optional":false,"field":"row"},{"type":"int64","optional":true,"field":"thread"},{"type":"string","optional":true,"field":"query"}],"optional":false,"name":"io.debezium.connector.mariadb.Source","version":1,"field":"source"},{"type":"struct","fields":[{"type":"string","optional":false,"field":"id"},{"type":"int64","optional":false,"field":"total_order"},{"type":"int64","optional":false,"field":"data_collection_order"}],"optional":true,"name":"event.block","version":1,"field":"transaction"},{"type":"string","optional":false,"field":"op"},{"type":"int64","optional":true,"field":"ts_ms"},{"type":"int64","optional":true,"field":"ts_us"},{"type":"int64","optional":true,"field":"ts_ns"}],"optional":false,"name":"biorx.master.reasoncode.Envelope","version":2},"payload":{"before":null,"after":{"ReasonCodeID":99955,"ReasonCodeGUID":"TESTTEST-D2A6-45EF-A592-ABE3323E6212","Action":0,"Code":"999","Description":"Test Reason","CreatedDT":1782305100000,"CreatedByID":999,"DeletedDT":null,"DeletedByID":null,"Synced":1,"Deleted":0,"CancelledOrder":1},"source":{"version":"3.5.2.Final","connector":"mariadb","name":"biorx","ts_ms":1783016286000,"snapshot":"false","db":"master","sequence":null,"ts_us":1783016286000000,"ts_ns":1783016286000000000,"table":"reasoncode","server_id":1,"gtid":"0-1-61","file":"mariadb-bin.000002","pos":26776,"row":0,"thread":null,"query":null},"transaction":null,"op":"c","ts_ms":1783016286705,"ts_us":1783016286705016,"ts_ns":1783016286705016500}}
```

## mariadb-connector.json versions
1. v1 (working but with consumer limitation in Fabric Eventstreams custom endpoint)
```
{
  "name": "mariadb-cdc-v6",
  "config": {
    "connector.class": "io.debezium.connector.mariadb.MariaDbConnector",
    "database.hostname": "localhost",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "toodles-zoO-SquirreL-19284",
    "database.server.id": "5401",
    "topic.prefix": "biorx3",
    "database.include.list": "master",
    "table.include.list": "master.reasoncode",
    "schema.history.internal.kafka.topic": "esehbn18tmfo040bvonhn8_eh",
    "schema.history.internal.kafka.bootstrap.servers": "esehbn18tmfo040bvonhn8.servicebus.windows.net:9093",
    "schema.history.internal.producer.security.protocol": "SASL_SSL",
    "schema.history.internal.producer.sasl.mechanism": "PLAIN",
    "schema.history.internal.producer.sasl.jaas.config": "",
    "schema.history.internal.consumer.security.protocol": "SASL_SSL",
    "schema.history.internal.consumer.sasl.mechanism": "PLAIN",
    "schema.history.internal.consumer.sasl.jaas.config":  "",
    "producer.override.security.protocol": "SASL_SSL",
    "producer.override.sasl.mechanism": "PLAIN",
    "producer.override.sasl.jaas.config":  "",
    "signal.enabled.channels": "",    
    "snapshot.mode": "no_data",
    "transforms": "route",
    "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.route.regex": "biorx3\\.master\\.(.*)",
    "transforms.route.replacement": "esehbn18tmfo040bvonhn8_eh",
    "include.schema.changes": "true"
  }
}
```
2. v2 changed to file storage for schema history
```
{
  "name": "mariadb-cdc-v6",
  "config": {
    "connector.class": "io.debezium.connector.mariadb.MariaDbConnector",
    "database.hostname": "localhost",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "toodles-zoO-SquirreL-19284",
    "database.server.id": "5401",
    "topic.prefix": "biorx3",
    "database.include.list": "master",
    "table.include.list": "master.reasoncode",

    "schema.history.internal": "io.debezium.storage.file.history.FileSchemaHistory",
    "schema.history.internal.file.filename": "C:/kafka/connect-data/schema-history.dat",

    "producer.override.security.protocol": "SASL_SSL",
    "producer.override.sasl.mechanism": "PLAIN",
    "producer.override.sasl.jaas.config": "",

    "signal.enabled.channels": "",
    "snapshot.mode": "no_data",

    "transforms": "route",
    "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.route.regex": "biorx3\\.master\\.(.*)",
    "transforms.route.replacement": "esehbn18tmfo040bvonhn8_eh",

    "include.schema.changes": "true"
  }
}
```