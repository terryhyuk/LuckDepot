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
from static.hosts import JWT_ALGORITHM, JWT_SECRET


async def access_control(request: Request, call_next):
    request.state.start = time.time()
    request.state.inspect = None
    request.state.user = None

    ip = request.headers["x-forwarded-for"] if "x-forwarded-for" in request.headers.keys() else request.client.host
    request.state.ip = ip.split(",")[0] if "," in ip else ip
    headers = request.headers
    # cookies = request.cookies

    url = request.url.path
    if await url_pattern_check(url, EXCEPT_PATH_REGEX) or url in EXCEPT_PATH_LIST:
        response = await call_next(request)
        return response
    try:
        # 일단은 JWT 검사 안함
        
        # if "authorization" in headers.keys():
        #     token_info = await token_decode(access_token=headers.get("Authorization"))
        #     request.state.user = UserToken(**token_info)
        #     # 토큰 없음
        # else:
        #     if "Authorization" not in headers.keys():
        #         raise ex.NotAuthorized()
        response = await call_next(request)
    except Exception as e:

        error = await exception_handler(e)
        error_dict = dict(status=error.status_code, msg=error.msg, detail=error.detail, code=error.code)
        response = JSONResponse(status_code=error.status_code, content=error_dict)

    return response


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
