-- https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html
-- get role arn from devops

-- syntax
create or replace storage integration <YOUR_STORAGE_INTEGRATION_NAME>
  type = external_stage
  storage_provider = s3
  storage_aws_role_arn = '<YOUR_ROLE_ARN>'
  enabled = true
  storage_allowed_locations = ('<YOUR_BUCKET_PATH>'); --  e.g. 's3://bucket/path/'

desc integration <YOUR_STORAGE_INTEGRATION_NAME>;

-- have devops update trust relationship policy

CREATE or replace STAGE <YOUR_STAGE_NAME>
url = '<YOUR_S3_PATH>' -- e.g. 's3://bucket/path/'
STORAGE_INTEGRATION = '<YOUR_STORAGE_INTEGRATION_NAME>'
COMMENT = '<YOUR_COMMENT>';

set search_param = 1;
COPY INTO @test_sample_data_extract/data.csv
FROM (
    SELECT distinct
    c.external_id lp_conversation_id
    ,a.type
    ,b.node_name
    ,b.text
    ,a.sent_at timestamp_utc
    FROM raw_optus.application_public.events a
    JOIN raw_optus.application_public.responses b ON a.id = b.event_id
    JOIN raw_optus.application_public.engagements c ON a.engagement_id = c.id
    WHERE  external_id = $search_param
    order by a.sent_at) 
//STORAGE_INTEGRATION = extract_test
FILE_FORMAT = ( TYPE = CSV null_if=('') COMPRESSION = None) 
OVERWRITE = TRUE 
SINGLE = TRUE 
HEADER = TRUE;


/*
-- json for role permission policy and trust relationship policy below


-- policy
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Put*"
            ],
            "Resource": [
                "arn:aws:s3:::xsell-data-engineering-test"
                "arn:aws:s3:::xsell-data-engineering-test/*"
            ],
            "Effect": "All"
            
        }    
    ]
}


--trust
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::210437325872:user/0x89-s-ohst7464"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "HH46454_SFCRole=5_jkGqRsAa6QkG9YQs7qHcdy0OteY="
                }
            }
        }
    ]
}
*/