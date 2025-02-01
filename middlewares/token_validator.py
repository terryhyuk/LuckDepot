import time
import typing
import re

import jwt

from jwt.exceptions import ExpiredSignatureError, DecodeError
from starlette.requests import Request
from starlette.responses import JSONResponse

from static.hosts import EXCEPT_PATH_LIST, EXCEPT_PATH_REGEX
from errors import exceptions as ex

from errors.exceptions import APIException
from static.models import UserToken
from static.hosts import JWT_ALGORITHM, JWT_SECRET, firebase_auth


async def access_control(request: Request, call_next):
    """
    ✅ Firebase JWT 토큰 검증 미들웨어
    """
    request.state.start = time.time()
    request.state.user = None  # 사용자 정보 초기화

    headers = request.headers
    url = request.url.path
    print(f"요청받은 url: {url}")
    
    # ✅ Authorization 헤더 가져오기
    auth_header = headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        if url in EXCEPT_PATH_LIST or re.match(EXCEPT_PATH_REGEX, url):
            print(f"✅ [예외처리] {url} 요청은 인증 없이 통과")
            return await call_next(request)
        else:
            print("❌ Authorization 헤더 없음 또는 형식 오류")
            return JSONResponse(status_code=401, content={"detail": "Unauthorized: Missing token"})

    token = auth_header.split("Bearer ")[1]  # "Bearer {JWT}"에서 JWT 추출
    print(f"📡 받은 JWT 토큰: {token}")

    try:
        decoded_token = firebase_auth.verify_id_token(token)  # ✅ Firebase JWT 검증
        request.state.user = decoded_token  # ✅ 사용자 정보 저장
        print(f"✅ 토큰 검증 성공: {decoded_token}")

    except firebase_auth.ExpiredIdTokenError:
        print("❌ 만료된 토큰")
        return JSONResponse(status_code=401, content={"detail": "Unauthorized: Expired token"})

    except firebase_auth.InvalidIdTokenError:
        print("❌ 잘못된 토큰")
        return JSONResponse(status_code=401, content={"detail": "Unauthorized: Invalid token"})

    except Exception as e:
        print(f"❌ Firebase 검증 중 오류 발생: {e}")
        return JSONResponse(status_code=500, content={"detail": f"Firebase token verification error: {str(e)}"})

    return await call_next(request)



async def url_pattern_check(path, pattern):
    result = re.match(pattern, path)
    if result:
        return True
    return False


async def token_decode(access_token):
    """
    :param access_token:
    :return:
    """
    try:
        access_token = access_token.replace("Bearer ", "")
        payload = jwt.decode(access_token, key=JWT_SECRET, algorithms=[JWT_ALGORITHM])
    except ExpiredSignatureError:
        raise ex.TokenExpiredEx()
    except DecodeError:
        raise ex.TokenDecodeEx()
    return payload


async def exception_handler(error: Exception):
    if not isinstance(error, APIException):
        error = APIException(ex=error, detail=str(error))
    return error
