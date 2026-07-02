# commands
## Browser
1. Get connector names
   1. http://localhost:8083/connectors
## Windows cmd
1. Kafka connector status
   1. curl -s "http://localhost:8083/connectors/mariadb-cdc/status"
   2. Stop Kafka broker 
      1. `.\bin\windows\kafka-server-stop.bat`
   3. Delete Kafka connector
      1. `curl -X DELETE http://localhost:8083/connectors/mariadb-cdc`
## Windows Powershell
1. Powershell
   1. Stop connector
      1. `Invoke-WebRequest -Method PUT -Uri "http://localhost:8083/connectors/<connector-name>/stop"`

Invoke-WebRequest -Method PUT -Uri "http://localhost:8083/connectors/mariadb-cdc/stop