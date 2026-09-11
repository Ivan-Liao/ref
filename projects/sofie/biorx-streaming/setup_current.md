1. Confirm VM name
   1. AZRSVBioRX-BI-Replica
2. my.ini config
   1. 604800 seconds is 7 days, a standard default retention period for binlog files
   2. log_slave_updates is needed if replication database instance.
   ```
   server-id = 1
   log_bin = mariadb-bin
   binlog_format = ROW
   binlog_row_image = FULL
   expire_log_seconds = 604800
   log_slave_updates = ON
   ```
3. user creation sfbiorxcdc
   1. password with Elango
   ```
   CREATE USER 'sfbiorxcdc'@'%' IDENTIFIED BY '<insert password here>'

   GRANT SELECT, SHOW DATABASES, REPLICATION SLAVE, BINLOG MONITOR, RELOAD, LOCK TABLES ON *.* TO 'sfbiorxcdc'@'%';
   
   FLUSH PRIVILEGES;
   ```
4. Restart MariaDB service
   1. Method depends on Linux or Windows system
5. Open Firewall Port on VM
   1. Source: <VNet CIDR>
   2. Source port ranges: *
   3. Destination: Any
   4. Destination port ranges: 3306
   5. Protocol: TCP
6. Register Microsoft.MessagingConnectors in Azure portal > Subscriptions > Resource Providers > search bar
7. Create VNet or use preexisting VNet
   1.  preexisting VNet VNET_AzDulles connected to prod VM
8. Create private subnet
   1. biorxcdc-subnet
   2. Starting address: 10.20.36.192
   3. /26 ... at least 30 addresses /27
   4. subnet delegation: Microsoft.MessagingConnectors/connector
9.  Setup user needs to be a capacity admin in Fabric
    1.  Fabric portal > admin portal > fabric capacity > capacity admins
10. Enable Fabric Workspace identity
   1. Name: FabricProd
   2. ID: b9ed41bd-0895-4793-9083-9bd0e57d2bff
   3. App ID: d24c7a8d-1672-4a6b-9f29-654e5a9b671f
11. Grant network contributor role on the connector VNET to workspace identity ID
12. Create Streaming VNet Data Gateway 
    1.  Resource group: SF_EDW_DEV
    2.  Virtual network: VNET_AzDulles
    3.  Subnet: biorxcdc-subnet
    4.  Share this Gateway with Setup User
13. Create Fabric connection
    1.  Name: biorx-cdc-connection
    2.  Connection type: MySQL
    3.  Server: 10.20.37.4
        1.  This is the VM IP
    4.  Database: master
    5.  Username: <Insert_Username_HERE>
    6.  Password: <Insert_Password_HERE>
    7.  Share this Connection with Setup User
14. Configure Eventstream Source
    1.  Source name: biorx
    2.  Cloud connection:
    3.  Port: 3306
    4.  Tables(s): <list_of_tables_with_full_identifiers>
    5.  Server ID: <unique_server_id_between_all_eventstream_connectors>
    6.  Snapshot mode: <initial_or_nodata>