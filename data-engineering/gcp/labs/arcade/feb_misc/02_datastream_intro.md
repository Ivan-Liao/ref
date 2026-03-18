1. Activate Cloud Shell
2. Create postgreSQL Cloud SQL instance
```
POSTGRES_INSTANCE=postgres-db
DATASTREAM_IPS=34.74.216.163,34.75.166.194,104.196.6.24,34.73.50.6,35.237.45.20
gcloud sql instances create \
    ${POSTGRES_INSTANCE} \
    --database-version=POSTGRES_14 \
    --cpu=2 --memory=10GB \
    --authorized-networks=${DATASTREAM_IPS} \
    --region=us-east1 \
    --root-password pwd \
    --database-flags=cloudsql.logical_decoding=on
```
   1. Note instance's IP
3. Connect to instance
   1. 
```
gcloud sql connect postgres-db --user=postgres
```
4. Create schema and tables
```
CREATE SCHEMA IF NOT EXISTS test;

CREATE TABLE IF NOT EXISTS test.example_table (
id  SERIAL PRIMARY KEY,
text_col VARCHAR(50),
int_col INT,
date_col TIMESTAMP
);

ALTER TABLE test.example_table REPLICA IDENTITY DEFAULT; 

INSERT INTO test.example_table (text_col, int_col, date_col) VALUES
('hello', 0, '2020-01-01 00:00:00'),
('goodbye', 1, NULL),
('name', -987, NOW()),
('other', 2786, '2021-01-01 00:00:00');
```
5. Prepare publication for replication
```
CREATE PUBLICATION test_publication FOR ALL TABLES;
ALTER USER POSTGRES WITH REPLICATION;
SELECT PG_CREATE_LOGICAL_REPLICATION_SLOT('test_replication', 'pgoutput');
```
6. Create datastream
   1. PostgreSQL connection profile settings
      1. Connection profile name: postgres-cp
      2. Region: us-east1
      3. Hostname or IP: <Found in CloudSQL instances>
      4. Username: postgres
      5. Password: <Entered manually>
      6. Database: postgres
      7. Encryption type: None
      8. IP allowlisting
      9. Run Test
   2.  Bigquery connection profile settings
       1.  Connection profile name: bigquery-cp
       2.  Region: us-east1
7. Check for change replication
```
INSERT INTO test.example_table (text_col, int_col, date_col) VALUES
('abc', 0, '2022-10-01 00:00:00'),
('def', 1, NULL),
('ghi', -987, NOW());

UPDATE test.example_table SET int_col=int_col*2; 

DELETE FROM test.example_table WHERE text_col = 'abc';
```