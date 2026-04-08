1. Setup Bigquery and pubsub
```
gcloud config set project qwiklabs-gcp-02-c1013bdfdc3f
export GCP_PROJECT_ID="qwiklabs-gcp-02-c1013bdfdc3f"
export GCP_REGION="us-west1"
export BUCKET_NAME="qwiklabs-gcp-02-c1013bdfdc3f-bucket"
export GEMINI_MODEL_ID="gemini-2.5-flash"


bq mk --location=us-west1 esports_analytics
bq mk --table esports_analytics.raw_chat_messages \
message_id:STRING,user_id:STRING,timestamp:TIMESTAMP,message_text:STRING,game_id:STRING,server_region:STRING
bq mk \
--table \
--description "Table to store unsportsmanlike messages from esports analytics." \
--time_partitioning_field timestamp \
--time_partitioning_type DAY \
esports_analytics.unsportsmanlike_messages \
message_id:STRING,user_id:STRING,timestamp:TIMESTAMP,message_text:STRING,message_type:STRING,game_id:STRING,server_region:STRING


gcloud bigtable instances create instance \
    --display-name="My Bigtable Instance" \
    --cluster-config=id=my-cluster,zone=us-west1-b,nodes=1
cbt -instance instance createtable unsportsmanlike families=messages


gcloud pubsub topics create esports_messages_topic
gcloud pubsub subscriptions create esports_messages_topic-sub --topic=esports_messages_topic
```
2. Create python script for generating messages
   1. in ../../pubsub/chat-moderation/message_generator.py
3. Create python script for streamlit app
   1. in ../../pubsub/chat-moderation/app.py
4. Setup Vertex AI with Bigquery
   1. Explorer panel >> add data >> vertex AI: BigQuery Federation
   2. Note service account from connection info pane and grant Vertex AI User Role
   3. Create BigQuery remote model
```
CREATE OR REPLACE MODEL `esports_analytics.gemini_model`
REMOTE WITH CONNECTION `us-west1.esports_qwiklab`
OPTIONS (ENDPOINT = 'gemini-2.5-flash');
```
5. Bigquery Analysis
```
SELECT * FROM `qwiklabs-gcp-02-c1013bdfdc3f.esports_analytics.raw_chat_messages` LIMIT 1000


# enable continous query mode option
INSERT INTO `esports_analytics.unsportsmanlike_messages` (message_id, user_id, timestamp, message_text, message_type, game_id, server_region)
SELECT
message_id,
user_id,
timestamp,
message_text,
ml_generate_text_llm_result AS category,
game_id,
server_region
FROM
ML.GENERATE_TEXT(
    MODEL `esports_analytics.gemini_model`,
    (
    SELECT
    *,
    CONCAT(
    "You are an expert content moderator for an online competitive game. Your task is to classify the following chat message as either 'sportsmanlike' or 'unsportsmanlike'.",
    "\n\n",
    "An 'unsportsmanlike' message falls into one of these categories:",
    "\n- personal_harassment: Insults, threats, or attacks directed at another player.",
    "\n- spamming: Repetitive, irrelevant, or unsolicited messages.",
    "\n- promoting_cheating: Advertising or encouraging the use of cheats, hacks, or exploits.",
    "\n- impersonation: Falsely pretending to be another player, admin, or staff member.",
    "\n\n",
    "Here are some examples:",
    "\nMessage: 'EZ clap, you guys are trash uninstall the game.' -> unsportsmanlike",
    "\nMessage: 'get my aimbot for free at supercheats dot com!' -> unsportsmanlike",
    "\nMessage: 'ggwp, that was a really close match!' -> sportsmanlike",
    "\n\n",
    "Based on these definitions and examples, classify the following message. Respond with *only* the single word: 'sportsmanlike' or 'unsportsmanlike'.",
    "\n\nMessage: ",
    message_text
) AS prompt
    FROM
    APPENDS(TABLE `esports_analytics.raw_chat_messages`)
    ),
    STRUCT(
    2048 AS max_output_tokens,
    0.2 AS temperature,
    1 AS candidate_count,
    TRUE AS flatten_json_output
    )
)
WHERE
ml_generate_text_llm_result = 'unsportsmanlike';


# validate 
SELECT * FROM `qwiklabs-gcp-02-c1013bdfdc3f.esports_analytics.unsportsmanlike_messages` LIMIT 1000


# export data
EXPORT DATA
OPTIONS (
   format = 'CLOUD_BIGTABLE',
   auto_create_column_families=TRUE,
   uri = 'https://bigtable.googleapis.com/projects/qwiklabs-gcp-02-c1013bdfdc3f/instances/instance/tables/unsportsmanlike'
)
AS
   SELECT
      user_id AS rowkey,
      message_text,
      timestamp
   FROM
      APPENDS(TABLE `esports_analytics.unsportsmanlike_messages`)
```