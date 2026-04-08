import streamlit as st
import pandas as pd
import os
from google.cloud import bigtable
from google.api_core.exceptions import GoogleAPICallError, PermissionDenied, NotFound
from google.auth.exceptions import DefaultCredentialsError

# --- Page Configuration ---
st.set_page_config(
    page_title="Esports Moderation Dashboard",
    page_icon="️",
    layout="wide"
)

# --- Configuration ---
PROJECT_ID = os.getenv("GCP_PROJECT_ID")
INSTANCE_ID = "instance"
TABLE_ID = "unsportsmanlike"

# --- Bigtable Connection Caching ---

# Use @st.cache_resource to initialize the Bigtable client only once per session.
# This is the most robust way to prevent the file-watcher from causing an infinite loop.
# The client object is a "resource" that we want to persist across reruns.
@st.cache_resource
def init_bigtable_client():
    """Initializes and returns a Bigtable client, caching the resource."""
    try:
        # This client automatically uses Application Default Credentials (ADC).
        return bigtable.Client(project=PROJECT_ID, admin=True)
    except DefaultCredentialsError:
        st.error("Authentication Error: Could not find Google Cloud credentials. Please run `gcloud auth application-default login` in your terminal and restart the app.")
        return None
    except Exception as e:
        st.error(f"Failed to initialize Bigtable client: {e}")
        return None

# Use @st.cache_data to fetch and cache the actual data for a set TTL.
# It takes the client as an argument to use the cached connection.
@st.cache_data(ttl=30)
def get_moderation_data(_client):
    """
    Connects to Bigtable using a cached client and fetches all rows.
    The cache will expire after 30 seconds, fetching fresh data.
    """
    # If the client failed to initialize, return an empty DataFrame.
    if _client is None:
        return pd.DataFrame(), "Client not initialized."

    try:
        instance = _client.instance(INSTANCE_ID)
        table = instance.table(TABLE_ID)
        rows_data = []
        
        # To read all rows, simply call read_rows(). The library streams all rows by default.
        rows = table.read_rows()
        for row in rows:
            try:
                # Per your feedback, the row key is now treated as the unique user_id.
                row_key_str = row.row_key.decode('utf-8')
                user_id = row_key_str
                
                # Safely get the message text cell
                # The cbt output shows the column family is 'message_text' and the qualifier is empty.
                message_cell = row.cells.get('message_text', {}).get(b'')
                if not message_cell:
                    st.warning(f"Skipping user '{user_id}' because they have no data in the 'message_text' column family.")
                    continue
                
                message_text = message_cell[0].value.decode('utf-8')
                # The concept of a unique message_id per row is removed to match the schema.
                rows_data.append({"user_id": user_id, "message_text": message_text})

            except (KeyError, IndexError, ValueError) as e:
                st.warning(f"Could not parse row for user '{row.row_key.decode('utf-8')}': {e}")
                continue
        
        if not rows_data:
            return pd.DataFrame(), "No users with unsportsmanlike messages were found in the table."
        
        return pd.DataFrame(rows_data), None

    except PermissionDenied:
        return None, "Permission Denied: The application does not have permission to access Bigtable. Please check IAM roles for the principal running this app."
    except NotFound as e:
        return None, f"Bigtable resource not found. Please check if instance '{INSTANCE_ID}' and table '{TABLE_ID}' exist. Details: {e}"
    except Exception as e:
        return None, f"An unexpected error occurred while fetching data: {e}"

# --- Application UI ---
st.title(" Unsportsmanlike Conduct Moderation Dashboard")
st.markdown("This dashboard displays chat messages flagged for review from the esports platform.")

if st.button("Refresh Data"):
    # When refreshing, we need to clear both caches to ensure a full refresh.
    st.cache_resource.clear()
    st.cache_data.clear()
    st.rerun()

# 1. Initialize the client (this will be cached and run only once per session).
client = init_bigtable_client()

# 2. Fetch the data using the client (this will be cached for 30 seconds).
df, error_message = get_moderation_data(client)

if error_message:
    st.error(f"**Failed to load data:** {error_message}")
elif df.empty:
    st.info("No unsportsmanlike messages found in Bigtable.")
else:
    st.dataframe(df, use_container_width=True)

    st.subheader("Take Action")
    # The selection is now based on user_id, the unique key for each row.
    selected_user = st.selectbox("Select a user to review:", options=df['user_id'])
    
    if selected_user:
        message_details = df[df['user_id'] == selected_user].iloc[0]
        
        st.write(f"**User:** `{message_details['user_id']}`")
        st.write(f"**Last Flagged Message:**")
        st.info(f"'{message_details['message_text']}'")

        col1, col2, col3 = st.columns(3)
        with col1:
            if st.button("️ Suspend User (24h)", key=f"suspend_{selected_user}"):
                st.success(f"Action logged: Suspended user {message_details['user_id']} for 24 hours.")
        with col2:
            if st.button(" Ban User (Permanent)", key=f"ban_{selected_user}"):
                st.warning(f"Action logged: Permanently banned user {message_details['user_id']}.")
        with col3:
            if st.button(" Dismiss as False Positive", key=f"dismiss_{selected_user}"):
                st.info(f"Action logged: Dismissed flag for user {message_details['user_id']}.")