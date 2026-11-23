# Adhoc queries
.append stg_ordered_flat <| func_ordered_flat();

raw_ordered
| take 100
| where tostring(payload.op) in ("r", "c", "u", "d")

.delete table raw_ordered records <|
    raw_ordered
    | where tostring(payload.op) in ("r", "c", "u", "d")
    | where unixtime_milliseconds_todatetime(tolong(payload.after.LastModified)) < ago(336h)

stg_ordered_flat
| take 100
| where CDCOperation in ("r", "c", "u", "d")
| sort by LastModified desc 

-- stg_ordered_flat currently 47889
-- raw_ordered currently 47859

# Deployment
.disable materialized-view mv_ordered_latest

<-- unnecessary if operation is on materialized view and it was disabled
.cancel operation 88d820cd-0b79-40c3-8b98-cd7d99b53822 with (reason = "Hanging due to being active mv")

.rename materialized-view mv_ordered_latest to mv_ordered_latest_old

.rename materialized-view mv_ordered_latest_dev to mv_ordered_latest

.show operations 88d820cd-0b79-40c3-8b98-cd7d99b53822