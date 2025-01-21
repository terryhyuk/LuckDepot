from dataclasses import asdict
from typing import Optional

import uvicorn
from fastapi import FastAPI, Depends
from fastapi.security import APIKeyHeader
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.middleware.cors import CORSMiddleware
from database.conn import connection
import router.test as test
from static import hosts

def create_app():
    """
    앱 함수 실행
    :return:
    """
    app = FastAPI()

    # 데이터 베이스 이니셜라이즈
    connection.db.init_app(app)

    # 미들웨어 정의
    # app.add_middleware(middleware_class=BaseHTTPMiddleware, dispatch=access_control)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        # allow_origins=conf().ALLOW_SITE,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    # app.add_middleware(TrustedHostMiddleware, allowed_hosts=conf().TRUSTED_HOSTS, except_path=["/health"])

    # 라우터 정의
    app.include_router(test.router)
    print(hosts.POSTGRESQL_HOST)
    return app


app = create_app()

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
