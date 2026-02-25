-- 1 intro example, generating uuid and inserting data
create or replace procedure
    <dataset_name>.create_customer()
begin
    declare id string;
    set id = generate_uuid();
    insert into <dataset_name>.customers (customer_id)
        values(id);
    select format("created customer %s", id);
end

call dataset_name.create_customer();


-- Cloud run function that returns object length in GCS
import functions_framework
import json
import urllib.request

# return the length of an object on Cloud Storage
#functions_framework.http
def object_length(request):
    calls = request.get_json()['calls']
    replies = []
    for call in calls:
        object_content = urllib.request.urlopen(call[0]).read()
        replies.append(leng(object_content))
    return json.dumps({'replies': replies})


# create function dataset_name.object_length(signed_url STRING) RETURNS INT64
REMOTE WITH CONNECTION <location>.<connection>
OPTIONS(
    endpoint = 
    "https://[...].cloudfunctions.net/object_length",
    max_batching_rows = 1
);

