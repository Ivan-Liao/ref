1. Setup
```
export PROJECT_ID="qwiklabs-gcp-02-40f8dd50fc32"
export BUCKET_NAME="qwiklabs-gcp-02-40f8dd50fc32-bucket"


bq --location=US mk esports_analytics


# create file raw_events_schema.json
[
    {"name": "event_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "match_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "game_name", "type": "STRING", "mode": "NULLABLE"},
    {"name": "event_type", "type": "STRING", "mode": "NULLABLE"},
    {"name": "team_a_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "player_a_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "team_b_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "player_b_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "winner_player_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "winner_team_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "timestamp", "type": "TIMESTAMP", "mode": "NULLABLE"}
]
# make table with json schema
bq mk --table \
  qwiklabs-gcp-02-40f8dd50fc32:esports_analytics.raw_events \
  ./raw_events_schema.json


gcloud pubsub topics create esports_events_topic
gcloud pubsub subscriptions create esports_events_topic-sub --topic=esports_events_topic


# edit subscription option in UI
Delivery type = Write to BigQuery
dataset option = esports_analytics


# error message with more permissions needed for pubsub service account
1. find your esports_analytics dataset, click the three vertical dots (⋮) next to it, and select Share and then Manage Permissions
2. Add the Principal
3. Role BigQuery Data Editor


# Setup and run python pubsub script
# Script in ../pubsub/esports-demo/esports-simulation.py
pip install google-cloud-pubsub
python3 esports-simulation.py
```


2. Bigquery validation and analysis
```
SELECT * FROM `qwiklabs-gcp-02-40f8dd50fc32.esports_analytics.raw_events` LIMIT 1000

-- Query 1: Create the Player Leaderboard View
-- This view calculates player scores from raw events and ranks them.

CREATE OR REPLACE VIEW `esports_analytics.player_leaderboard_live` AS
SELECT
  RANK() OVER (ORDER BY SUM(CASE WHEN event_type = 'match_end' THEN 5 ELSE 1 END) DESC) as rank,
  winner_player_id AS player_id,
  SUM(CASE WHEN event_type = 'match_end' THEN 5 ELSE 1 END) AS total_score,
  MAX(timestamp) AS last_updated
FROM
  `qwiklabs-gcp-02-40f8dd50fc32.esports_analytics.raw_events`
WHERE
  winner_player_id IS NOT NULL
  AND (event_type = 'player_elimination' OR event_type = 'match_end')
GROUP BY
  winner_player_id;


-- Query 2: Create the Team Leaderboard View
-- This view calculates team wins from raw events and ranks them.

CREATE OR REPLACE VIEW `esports_analytics.team_leaderboard_live` AS
SELECT
  RANK() OVER (ORDER BY COUNT(*) DESC) as rank,
  winner_team_id AS team_id,
  COUNT(*) AS total_wins,
  MAX(timestamp) AS last_updated
FROM
  `qwiklabs-gcp-02-40f8dd50fc32.esports_analytics.raw_events`
WHERE
  winner_team_id IS NOT NULL
  AND event_type = 'match_end'
GROUP BY
  winner_team_id;
```