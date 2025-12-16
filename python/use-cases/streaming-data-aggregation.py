'''
Docstring for python.use-cases.streaming-data-aggregation

# pseudocode
SET window size to 5 minutes CREATE empty counter for endpoints SET current window start to empty

FOR each event in the stream: CONVERT event timestamp to datetime

IF no window exists:
    CALCULATE window start and end times

IF event is outside current window:
    OUTPUT aggregated counts
    RESET counters
    START a new window

INCREMENT count for the event's endpoint
OUTPUT final window if it exists
'''
# Generate test data
# colab !pip install Faker
# Import the Faker class for generating fake data
from faker import Faker
# Import random to randomly select API endpoints
import random
# Import datetime tools for formatting timestamps
from datetime import datetime
import json

# Create a Faker instance
# This object will generate realistic fake data
fake = Faker()

# Number of fake log records to generate
NUM_RECORDS = 10000

# List of allowed API endpoints (categorical values)
API_ENDPOINTS = [
    "/api/search",
    "/api/generate",
    "/api/summarize",
    "/api/list",
    "/api/echo",
    "/api/insert",
    "/api/update"
]

# This list will store all generated JSON objects
events = []

# Generate fake log events
for _ in range(NUM_RECORDS):
    # Generate a random datetime in the past year
    fake_datetime = fake.date_time_this_year()

    # Convert datetime to ISO 8601 string format
    timestamp = fake_datetime.isoformat()

    # Generate a random user ID
    # uuid4() is commonly used for unique identifiers
    user_id = fake.uuid4()

    # Randomly choose one endpoint from the allowed list
    endpoint = random.choice(API_ENDPOINTS)

    # Create the log event as a Python dictionary
    event = {
        "timestamp": timestamp,
        "user_id": user_id,
        "endpoint": endpoint
    }

    # Add the event to the list
    events.append(event)

# Sort by the 'age' key in ascending order
events = sorted(events, key=lambda x: x['timestamp'])

# Example: print the first 5 events to verify structure
for event in events[:5]:
    print(event)

file_path = "log_data.json"
with open(file_path, "w") as json_file:
    json.dump(events, json_file, indent=4)




#  Generate json results
from datetime import datetime, timedelta
from collections import defaultdict
import json

def aggregate_logs(event_stream):
    """
    Groups log events into 5-minute time windows
    and counts requests per endpoint.
    """

    # Length of each window
    WINDOW_SIZE = timedelta(minutes=60)

    # Start time of the current window
    current_window_start = None

    # Dictionary that automatically starts counts at 0
    endpoint_counts = defaultdict(int)


    for event in event_stream:
        # Convert timestamp string into a datetime object
        event_time = datetime.fromisoformat(event["timestamp"]) # iso 8601 strings are YYYY-MM-DDTHH:mm:ss.sss<Z or +/-hh:mm> ... there is also 2025-12-14T16:36:45 with no time zone

        # If this is the first event, create the first window
        if current_window_start is None:
            current_window_start = event_time.replace(
                minute=(event_time.minute // 5) * 5, # // is floor division to ensure start window on integer minute value
                second=0,
                microsecond=0
            )
            window_end = current_window_start + WINDOW_SIZE

        # If event is outside the current window, output results
        if event_time >= window_end:
            yield {
                "window_start": datetime.isoformat(current_window_start),
                "window_end": datetime.isoformat(window_end),
                "counts": dict(endpoint_counts),
                "total_count": sum(endpoint_counts.values()) # sums up list of values of endpoint counts as total count
            }

            # Reset for next window
            endpoint_counts.clear() # clears dict
            current_window_start = event_time.replace(
                minute=(event_time.minute // 5) * 5,
                second=0,
                microsecond=0
            )
            window_end = current_window_start + WINDOW_SIZE

        # Count the endpoint
        endpoint_counts[event["endpoint"]] += 1

    # Output the final window
    if endpoint_counts:
        yield {
            "window_start": datetime.isoformat(current_window_start),
            "window_end": datetime.isoformat(window_end),
            "counts": dict(endpoint_counts),
            "total_count": sum(endpoint_counts.values())
        }

with open('log_data.json', 'r') as f:
    event_stream = json.load(f)
    count_window_list = list(aggregate_logs(event_stream))

for event in count_window_list[:20]:
    print(event)
file_path = "log_data_count_window.json"
with open(file_path, "w") as json_file:
    json.dump(count_window_list, json_file, indent=4)