import os
from dotenv import load_dotenv

load_dotenv()  # loads .env if present

BASE_URL = os.getenv("TULIP_BASE_URL", "http://127.0.0.1:8000") + "/v1"
API_KEY  = os.getenv("TULIP_API_KEY", "DUMMY_KEY")
MODEL    = os.getenv("TULIP_MODEL", "gpt-oss-20b")
