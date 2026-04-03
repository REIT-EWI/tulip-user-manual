import os

from dotenv import load_dotenv

load_dotenv()  # loads .env if present

TUDELFT_TULIP_BASE_URL = os.getenv(
    "TUDELFT_TULIP_BASE_URL", "https://api.tulip.tudelft.nl"
)
TUDELFT_TULIP_CAPABILITY = os.getenv("TUDELFT_TULIP_CAPABILITY", "chat")
TUDELFT_TULIP_API_KEY = os.getenv("TUDELFT_TULIP_API_KEY", "DUMMY_KEY")
TUDELFT_TULIP_MODEL_ALIAS = os.getenv("TUDELFT_TULIP_MODEL_ALIAS", "chat")

# Construct full API URL
TUDELFT_TULIP_API_BASE_URL = f"{TUDELFT_TULIP_BASE_URL}/{TUDELFT_TULIP_CAPABILITY}/v1"
