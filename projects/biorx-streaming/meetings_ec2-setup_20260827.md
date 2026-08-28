1. AZRSVBioRX-BI-Replica
2. my.ini config
3. user creation sfbiorxcdc
   1. password with Elango
4. Microsoft.MessagingConnectors already registered
5. Using preexisting VNT VNET_AzDulles connected to prod VM
6. biorxcdc-subnet
   1. Starting address: 10.20.36.192
   2. /26
   3. enable private subnet
   4. subnet delegation 
      1. Microsoft.MessagingConnectors/connector
7. Workspace identity
   1. Name: FabricDev
   2. ID: f07fa8e3-feb0-4802-8705-6c92403861af
   3. App ID: 9611bdd3-35f3-4e88-8220-16052f5dd5f0
8. Grant contributor role on the connector VNET (ELANGO)
9. Create Streaming VNet Data Gateway 
10. Create Fabric connection
    1.  10.20.37.4
    2.  3306
    3.  master
    4.  Username (ELANGO)
    5.  Password (ELANGO)
11. Configure Eventstream Source