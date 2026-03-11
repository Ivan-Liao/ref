# pip install google-cloud-aiplatform

import vertexai
from vertexai.generative_models import GenerativeModel, Part

def load_image_from_url(prompt, image_uri=None):
    """
    Invokes the gemini-2.0-flash model with a text prompt and an optional 
    image stored in Google Cloud Storage.
    
    Args:
        prompt (str): The text instructions for the model.
        image_uri (str): The Cloud Storage URI (e.g., gs://bucket/image.jpg).
    """
    # Initialize Vertex AI with your project and location
    vertexai.init(project="YOUR_PROJECT_ID", location="us-central1")

    # Load the Gemini 2.0 Flash model
    model = GenerativeModel("gemini-2.0-flash")

    # Prepare the content list
    # Multimodal models accept a list of parts (text and/or images)
    content_parts = [prompt]
    
    if image_uri:
        # Create a Part object from the GCS URI
        # Note: Ensure the service account has Storage Object Viewer permissions
        image_part = Part.from_uri(
            uri=image_uri, 
            mime_type="image/jpeg"  # Adjust mime_type based on your file
        )
        content_parts.append(image_part)

    # Generate the response
    response = model.generate_content(content_parts)

    return response.text

# Example Usage:
# result = load_image_from_url(
#     prompt="Describe the contents of this image in detail.",
#     image_uri="gs://my-bucket-name/sample-image.jpg"
# )
# print(result)