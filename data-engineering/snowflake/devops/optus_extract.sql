use role reporting_optus_role;
use database raw_optus;
COPY INTO @optus_extract_stage/scheduled/test_2022-07-18_10-34.csv
FROM (
    -- CTE to bring in responses linked to events.  
    WITH responses_in_engagements AS (
    SELECT 
       ra_evts.ID                 AS EVENT_ID
      ,ra_evts.SENT_AT            AS TIME_STAMP
      ,ra_evts.TYPE               AS TYPE
      ,ra_evts.ENGAGEMENT_ID      AS ENGAGEMENT_ID
      ,ra_responses.NODE_NAME     AS "NODE_NAME"
      ,ra_responses.TEXT          AS "RESPONSE"
    FROM "RAW_OPTUS"."APPLICATION_PUBLIC"."EVENTS"           ra_evts
    INNER JOIN "RAW_OPTUS"."APPLICATION_PUBLIC"."RESPONSES"  ra_responses
      ON ra_evts.ID = ra_responses.EVENT_ID
    WHERE TRUE
      AND ra_evts.SENT_AT >= date_trunc('MONTH', dateadd('month', -1, CURRENT_DATE()))
      AND ra_evts.SENT_AT <= last_day(dateadd('month', -1, CURRENT_DATE()),'MONTH')
  ),engagement_sample_4_percent AS (
    SELECT 
       DISTINCT ID 
    FROM "RAW_OPTUS"."APPLICATION_PUBLIC"."ENGAGEMENTS" sample (90)
  )
  SELECT 
     ENGAGEMENT_ID              AS LP_CONVERSATION_ID
    ,TYPE
    ,NODE_NAME
    ,listagg(RESPONSE, '|||||') AS RESPONSES
    ,TIME_STAMP
  FROM responses_in_engagements ri_engagements
  INNER JOIN engagement_sample_4_percent es4_percent
    ON ri_engagements.ENGAGEMENT_ID = es4_percent.ID
  GROUP BY 1,2,3,5;
)
FILE_FORMAT = standard_csv_format
OVERWRITE = TRUE 
SINGLE = TRUE 
HEADER = TRUE;

-- Test 1, POC test
COPY INTO @optus_extracts/monthly-202206_four-percent-sample-engagements_2022-07-12.csv
FROM (
WITH responses_in_engagements AS (
  SELECT 
     ra_events.ID                 AS EVENT_ID
    ,ra_events.SENT_AT            AS TIME_STAMP
    ,ra_events.TYPE               AS TYPE
    ,ra_events.ENGAGEMENT_ID      AS ENGAGEMENT_ID
    ,ra_responses.NODE_NAME     AS "NODE_NAME"
    ,ra_responses.TEXT          AS "RESPONSES"
  FROM "RAW_OPTUS"."APPLICATION_OPTUS"."EVENTS"           ra_events
  INNER JOIN "RAW_OPTUS"."APPLICATION_OPTUS"."RESPONSES"  ra_responses
    ON ra_events.ID = ra_responses.EVENT_ID
  WHERE TRUE
    AND ra_events.SENT_AT >= date_trunc('MONTH', dateadd('month', -1, CURRENT_DATE()))
    AND ra_events.SENT_AT <= last_day(dateadd('month', -1, CURRENT_DATE()),'MONTH')
),engagement_sample_4_percent AS (
  SELECT 
     DISTINCT ENGAGEMENT_ID 
  FROM responses_in_engagements sample (4)
)
SELECT 
   ENGAGEMENT_ID
  ,TYPE
  ,NODE_NAME
  ,listagg(RESPONSES, '\n\n')   AS RESPONSES
  ,TIME_STAMP
FROM responses_in_engagements ri_engagements
INNER JOIN engagement_sample_four_percent esf_percent
  ON ri_engagements.ENGAGEMENT_ID = esf_percent.ID
GROUP BY 1,2,3,5
) 
FILE_FORMAT = ( TYPE = CSV null_if=('') COMPRESSION = None) 
OVERWRITE = TRUE 
SINGLE = TRUE 
HEADER = TRUE;

-- Test 2, at workPre production test
COPY INTO @optus_extract_stage/TEST_2022-07-18_10-34.csv
FROM (
  WITH responses_in_engagements AS (
    SELECT 
       ra_evts.ID                 AS EVENT_ID
      ,ra_evts.SENT_AT            AS TIME_STAMP
      ,ra_evts.TYPE               AS TYPE
      ,ra_evts.ENGAGEMENT_ID      AS ENGAGEMENT_ID
      ,ra_responses.NODE_NAME     AS "NODE_NAME"
      ,ra_responses.TEXT          AS "RESPONSES"
    FROM "RAW_OPTUS"."APPLICATION_OPTUS"."EVENTS"           ra_evts
    INNER JOIN "RAW_OPTUS"."APPLICATION_OPTUS"."RESPONSES"  ra_responses
      ON ra_evts.ID = ra_responses.EVENT_ID
  ),engagement_sample_4_percent AS (
    SELECT 
       DISTINCT ID 
    FROM "RAW_OPTUS"."APPLICATION_OPTUS"."ENGAGEMENTS" sample (80)
  )
  SELECT 
     ENGAGEMENT_ID
    ,TYPE
    ,NODE_NAME
    ,listagg(RESPONSES, '\n\n')
    ,TIME_STAMP
  FROM responses_in_engagements ri_engagements
  INNER JOIN engagement_sample_4_percent es4_percent
    ON ri_engagements.ENGAGEMENT_ID = es4_percent.ID
  GROUP BY 1,2,3,5
) 
FILE_FORMAT = ( TYPE = CSV null_if=('') COMPRESSION = None) 
OVERWRITE = TRUE 
SINGLE = TRUE 
HEADER = TRUE;