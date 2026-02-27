1. mk
   1. mk dataset: bq -- location<location> mk <dataset_name>
   2. mk table bq --location=us-west1 mk \
                    --time_partitioning_field timestamp \
                    --schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
                    timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
                    passenger_count:integer -t taxirides.realtime