```
bq mk work_day


bq mk --schema employee_id:integer,device_id:string,username:string,department:string,office:string -t work_day.employee


bq load --source_format=CSV --autodetect --noreplace  work_day.employee gs://qwiklabs-gcp-03-c0271adb007e-d6vz-bucket/employees.csv 
```