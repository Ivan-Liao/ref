- [MariaDB binlog setup](#mariadb-binlog-setup)
- [MariaDB debezium user creation](#mariadb-debezium-user-creation)
- [Configure VNET settings](#configure-vnet-settings)
- [Azure VM permissions](#azure-vm-permissions)
- [Eventstream to Eventhouse](#eventstream-to-eventhouse)
- [Eventhouse KQL Update Policy](#eventhouse-kql-update-policy)
- [Eventhouse Materialized View](#eventhouse-materialized-view)
- [Eventhouse Real time dashboard](#eventhouse-real-time-dashboard)
- [Connect Fabric to PowerBI](#connect-fabric-to-powerbi)
- [references](#references)
  - [MariaDB SQL references](#mariadb-sql-references)


# MariaDB binlog setup
1. Login via command prompt or powershell
   1. `mariadb -u root -p`
2. Check binlog status
   1. `SHOW VARIABLES LIKE 'log_bin';`
   2. `SHOW VARIABLES LIKE 'binlog_format';`
   3. `SHOW VARIABLES LIKE 'binlog_row_image';`
   4. `SHOW VARIABLES LIKE 'binlog_expire_logs_seconds';`
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
binlog_expire_logs_seconds=300000
```
4. Stop and restart MariaDB service
```
# change directory to MariaDB bin directory
cd "C:\Program Files\MariaDB 12.0\bin" 

.\mariadb-admin.exe -u root -p shutdown 

# need backtick to escape double quotes to handle space in defaults file path
Start-Process -FilePath "C:\Program Files\MariaDB 12.0\bin\mariadbd.exe" -ArgumentList "--defaults-file=`"C:\SFDevDB\MariaDB 12.0\data\my.ini`"" -WindowStyle Hidden


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
Test-NetConnection -ComputerName esehbn9kd0zwt2ixox3m9p.servicebus.windows.net:9093 -Port 9093
telnet esehbn9kd0zwt2ixox3m9p.servicebus.windows.net:9093 9093
```

# Azure VM permissions
1. Go to VM where MariaDB is in Azure Portal
2. IAM > Add Network Contributer
   1. Access to User, group, or service principal
   2. Workspace ID from Fabric (search by name, then by id)

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
## MariaDB SQL references
```
# list tables
```
SHOW TABLES;
SELECT * FROM reason LIMIT 5;
SELECT * FROM reasoncode where DeletedDT is null LIMIT 5;
INSERT into reasoncode (ReasonCodeID, ReasonCodeGUID, Action, Code, Description, CreatedDT, CreatedByID, DeletedDT, DeletedByID, Synced, Deleted, CancelledOrder) VALUES (99955,'TESTTEST-D2A6-45EF-A592-ABE3E4CE6112', 0, 999, 'Test Reason', '2026-06-24 12:45:00', 999, NULL, NULL, 1, 0, 1);
SELECT * FROM reasoncode where ReasonCodeID = 99955;
DELETE FROM reasoncode where ReasonCodeID = 99955;
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
    "schema.history.internal.producer.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"";",
    "schema.history.internal.consumer.security.protocol": "SASL_SSL",
    "schema.history.internal.consumer.sasl.mechanism": "PLAIN",
    "schema.history.internal.consumer.sasl.jaas.config":  "";",
    "producer.override.security.protocol": "SASL_SSL",
    "producer.override.sasl.mechanism": "PLAIN",
    "producer.override.sasl.jaas.config":  "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"";",
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
    "producer.override.sasl.jaas.config": "";",

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