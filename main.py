
import uvicorn
from fastapi import FastAPI, Depends
from starlette.middleware.base import BaseHTTPMiddleware
from fastapi.security import APIKeyHeader
from starlette.middleware.cors import CORSMiddleware
from middlewares.trusted_hosts import TrustedHostMiddleware
from database.conn import connection
from router.test import router as test_router
from router.auth import router as auth_router
from middlewares.token_validator import access_control
from static.hosts import TRUSTED_HOSTS

API_KEY_HEADER = APIKeyHeader(name="Authorization", auto_error=False)

def create_app():
    """
    앱 함수 실행
    :return:
    """
    app = FastAPI()

    # 데이터 베이스 이니셜라이즈
    connection.db.init_app(app)

    # 미들웨어 정의
    app.add_middleware(middleware_class=BaseHTTPMiddleware, dispatch=access_control)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        # allow_origins=conf().ALLOW_SITE,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    app.add_middleware(TrustedHostMiddleware, allowed_hosts=TRUSTED_HOSTS, except_path=["/health"])

    return app


app = create_app()

app.include_router(auth_router, tags=["Auth"], prefix="/auth")
app.include_router(test_router, tags=["Test"],prefix="/test", dependencies=[Depends(API_KEY_HEADER)])
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
