import json
import random
import uuid
import asyncio
import os
from google.cloud import pubsub_v1
from datetime import datetime, timezone
import vertexai
from vertexai.generative_models import GenerativeModel


# Categories for unsportsmanlike conduct, based on common EULA violations.
VIOLATION_CATEGORIES = [
    "personal_harassment",
    "spamming",
    "promoting_cheating",
    "impersonation"
]

# Categories for regular, sportsmanlike chat to create a balanced dataset.
SPORTSMANLIKE_CATEGORIES = [
    "positive_reinforcement", # e.g., "nice shot!", "great work team"
    "team_strategy",          # e.g., "let's push B", "cover me, I'm planting"
    "asking_for_help",        # e.g., "can someone drop me a weapon?", "need backup at alpha"
    "good_game_comment",      # e.g., "gg", "that was a close one"
    "neutral_observation"     # e.g., "looks like they're rushing A", "2 enemies left"
]


# In-game users for the simulation
USERS = [
    f"Player{str(uuid.uuid4())[:8]}" for _ in range(20)
]

# Generate_chat_message function
async def generate_chat_message(model: GenerativeModel):
    """
    Generates a single chat message (either sportsmanlike or unsportsmanlike)
    by calling the Vertex AI Gemini API.

    Args:
        model (GenerativeModel): An initialized Vertex AI GenerativeModel instance.

    Returns:
        dict: A dictionary representing the chat message.
    """
    user = random.choice(USERS)

    # Decide whether to generate a sportsmanlike or unsportsmanlike message.
    is_sportsmanlike = random.random() < 0.7  # 70% chance of being sportsmanlike

    if is_sportsmanlike:
        message_type = "sportsmanlike"
        category = random.choice(SPORTSMANLIKE_CATEGORIES)
        prompt_instruction = "Generate a short, friendly, sportsmanlike online gaming chat message."
    else:
        message_type = "unsportsmanlike"
        category = random.choice(VIOLATION_CATEGORIES)
        prompt_instruction = "Generate a short, toxic, unsportsmanlike online gaming chat message."

    prompt = (
        f"{prompt_instruction} "
        f"The message must be a clear example of '{category}'. "
        f"The message must sound like it was typed by a real person in a fast-paced game. "
        f"Don't focus on childish like messages... For example, don't use 'your mom...' jokes. "
        f"Do not add any introduction, explanation, or quotes. "
        f"Just return the raw chat message text itself."
    )

    message_text = f"Fallback message: A user posted a message classified as {category}."

    try:
        # Make the asynchronous API call to Gemini via the Vertex AI SDK.
        response = await model.generate_content_async(prompt)
        # Ensure that if the model returns an empty response, we handle it gracefully.
        if response.text:
            message_text = response.text.strip().strip('"')

    except Exception as e:
        print(f"Error calling Vertex AI API: {e}. Using fallback message.")

    message = {
        "message_id": str(uuid.uuid4()),
        "user_id": user,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "message_text": message_text,
        "message_type": message_type,
        "category": category,
        "game_id": "game-session-abc-123",
        "server_region": random.choice(["NA-East", "NA-West", "EU-Central", "Asia-Pacific"])
    }
    return message

async def simulate_chat_stream(project_id, location, topic_id):
    """
    Simulates a stream of chat messages and publishes them to Pub/Sub.

    Args:
        project_id (str): Your Google Cloud project ID.
        location (str): The GCP region for the Vertex AI API call (e.g., "us-central1").
        topic_id (str): The Pub/Sub topic ID to publish to.
    """
    # Initialize Vertex AI
    vertexai.init(project=project_id, location=location)
    model = GenerativeModel(GEMINI_MODEL_ID)

    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(project_id, topic_id)

    print(f"Publishing messages to {topic_path}...")
    print(f"Using Vertex AI in project '{project_id}' region '{location}'...")
    print("Starting chat simulation with Gemini... Press Ctrl+C to stop.")
    print("-" * 50)

    try:
        while True:
            # Generate a message with the updated async function
            chat_message = await generate_chat_message(model)

            # Create a copy of the dictionary to modify for the Pub/Sub message.
            message_to_publish = chat_message.copy()
            # Remove the keys that are not needed in the destination table.
            message_to_publish.pop('message_type', None)
            message_to_publish.pop('category', None)

            # Encode the modified dictionary for publishing.
            message_data = json.dumps(message_to_publish).encode("utf-8")

            future = publisher.publish(topic_path, data=message_data)

            # This line for logging still works because it uses the original 'chat_message' dictionary.
            print(f"Published {chat_message['message_type']} message to Pub/Sub.")
            # This detailed log only prints the message sent to Pub/Sub.
            print(json.dumps(message_to_publish, indent=4))
            print("-" * 50)

            await asyncio.sleep(random.uniform(2.0, 5.0))

    except KeyboardInterrupt:
        print("\nSimulation stopped.")
    except Exception as e:
        print(f"An unexpected error occurred in the simulation loop: {e}")

if __name__ == "__main__":
    try:
        # Load configuration from environment variables for better security and portability.
        GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID")
        if not GCP_PROJECT_ID:
            raise ValueError("GCP_PROJECT_ID environment variable not set.")
        
        # Add GCP_REGION for Vertex AI initialization
        GCP_REGION = os.getenv("GCP_REGION")
        if not GCP_REGION:
            raise ValueError("GCP_REGION environment variable not set (e.g., 'us-central1').")

        PUBSUB_TOPIC_ID = os.getenv("PUBSUB_TOPIC_ID", "esports_messages_topic")

        GEMINI_MODEL_ID = os.environ.get('GEMINI_MODEL_ID')   #Your Gemini Model ID


        asyncio.run(simulate_chat_stream(GCP_PROJECT_ID, GCP_REGION, PUBSUB_TOPIC_ID))
    except ValueError as e:
        print(f"Configuration Error: {e}")
    except KeyboardInterrupt:
        print("\nExiting program.")