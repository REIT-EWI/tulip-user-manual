import os

from dotenv import load_dotenv

load_dotenv()  # loads .env if present

TUDELFT_TULIP_BASE_URL = os.getenv(
    "TUDELFT_TULIP_BASE_URL", "https://api.tulip.tudelft.nl"
)
TUDELFT_TULIP_CAPABILITY = os.getenv("TUDELFT_TULIP_CAPABILITY", "chat")
TUDELFT_TULIP_API_KEY = os.getenv("TUDELFT_TULIP_API_KEY", "DUMMY_KEY")
TUDELFT_TULIP_MODEL_ALIAS = os.getenv("TUDELFT_TULIP_MODEL_ALIAS", "chat")

# Normalize TUDELFT_TULIP_BASE_URL to capability/v1. Docs recommend host root only,
# but we also accept URLs that already include capability or capability/v1.
_base_url = TUDELFT_TULIP_BASE_URL.rstrip("/")
if _base_url.endswith("/v1"):
    TUDELFT_TULIP_BASE_URL = _base_url
elif _base_url.endswith(f"/{TUDELFT_TULIP_CAPABILITY}"):
    TUDELFT_TULIP_BASE_URL = f"{_base_url}/v1"
else:
    TUDELFT_TULIP_BASE_URL = f"{_base_url}/{TUDELFT_TULIP_CAPABILITY}/v1"
