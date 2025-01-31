import os
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, auth

cred = credentials.Certificate("lucky-depot-firebase-adminsdk-fbsvc-f5947922f7.json")  # 서비스 계정 키 경로
firebase_admin.initialize_app(cred)

firebase_auth = auth

load_dotenv()
POSTGRESQL_HOST = os.getenv('POSTGRESQL_HOST')
JWT_SECRET = os.getenv("JWT_SECRET")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM")
EXCEPT_PATH_LIST = ["/", "/openapi.json", 
    "/login/google",  # ✅ 로그인 API
    "/signup",  # ✅ 회원가입 API (필요하면 추가)
    "/healthcheck"  # ✅ 서버 상태 확인 API (필요하면 추가)
]
EXCEPT_PATH_REGEX = "^(/docs|/redoc|/auth)"
TRUSTED_HOSTS = ["*"]
ALLOW_SITE = ["*"]
