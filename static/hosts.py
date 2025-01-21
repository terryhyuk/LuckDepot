import os
from dotenv import load_dotenv

load_dotenv()
POSTGRESQL_HOST = os.getenv('POSTGRESQL_HOST')
JWT_SECRET = os.getenv("JWT_SECRET")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM")
EXCEPT_PATH_LIST = ["/", "/openapi.json"]
EXCEPT_PATH_REGEX = "^(/docs|/redoc|/auth)"
TRUSTED_HOSTS = ["*"]
ALLOW_SITE = ["*"]
