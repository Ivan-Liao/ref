1. AZRSVBioRX-BI-Replica
2. my.ini config
3. user creation sfbiorxcdc
   1. password with Elango
```
CREATE USER 'sfbiorxcdc'@'%' IDENTIFIED BY '<insert password here>'

GRANT SELECT, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'sfbiorxcdc'@'%';
```

REPL_access!_S3cure321
4. Microsoft.MessagingConnectors already registered
5. Using preexisting VNT VNET_AzDulles connected to prod VM
6. biorxcdc-subnet
   1. Starting address: 10.20.36.192
   2. /26
   3. enable private subnet
   4. subnet delegation 
      1. Microsoft.MessagingConnectors/connector
7. Fabric portal > admin portal > fabric capacity > capacity admins
8. Workspace identity
   1. Name: FabricProd
   2. ID: b9ed41bd-0895-4793-9083-9bd0e57d2bff
   3. App ID: d24c7a8d-1672-4a6b-9f29-654e5a9b671f
9.  Grant network contributor role on the connector VNET (ELANGO) to workspace identity
10. Create Streaming VNet Data Gateway 
11. Create Fabric connection
    1.  Name: 
    2.  10.20.37.4
    3.  3306
    4.  master
    5.  Username (ELANGO)
    6.  Password (ELANGO)
    7.  Share this connection with developer
12. Configure Eventstream Source