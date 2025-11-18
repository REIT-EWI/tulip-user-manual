import os
from dotenv import load_dotenv

load_dotenv()  # loads .env if present

BASE_URL = os.getenv("OPENAI_BASE_URL", "http://127.0.0.1:8000") + "/v1"
API_KEY  = os.getenv("OPENAI_API_KEY", "DUMMY_KEY")
MODEL    = os.getenv("OPENAI_MODEL", "gpt-oss-20b")
