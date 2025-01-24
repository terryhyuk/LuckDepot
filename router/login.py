from database.model.user import User
from database.model.category import Category
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db
from errors import exceptions as ex
from static.models import GoogleRegister
from static.hosts import firebase_auth


router = APIRouter()

"""
    get : 조회 // status:200
    post : 생성, 개인정보 조회 // status:201
    put : 수정 //    기존 리소스가 수정된 경우: 200 (OK)
                    전송 성공 후 자원이 생성됬을 경우: 201 (Created)
                    전송은 했지만 전송할 데이터가 없는 경우: 204 (No Content)
    delete : 삭제
"""

# 모든 상품 가져오는 API
@router.post("/", status_code=200)
async def index(user = GoogleRegister, session: Session = Depends(db.session)):
    """
    `구글 로그인`\n
    DB에 저장된 중복 유저가 있나 확인하고  \n
    없다면 DB에 저장하고 반환
    :return:
    """
    
    # return {"result" :product}



@router.post("/google")
async def google_login(token: str, session: Session = Depends(db.session)):
    """
    Firebase Google 로그인 처리
    :param id_token: 클라이언트에서 전달된 Firebase ID 토큰
    :param session: SQLAlchemy 세션
    :return: 사용자 정보 또는 오류 메시지
    """
    print(f"Recieved JWT Token : \n{token}")
    try:
        # Firebase ID 토큰 검증
        decoded_token = firebase_auth.verify_id_token(token)
        firebase_uid = decoded_token["uid"]  # Firebase 사용자 고유 ID
        name = decoded_token.get("name", "Unknown")  # 사용자 이름
        email = decoded_token.get("email", None)  # 사용자 이메일 (옵션)

        # DB에서 사용자 검색
        user = session.query(User).filter(User.id == firebase_uid).first()

    #     if user:
    #         # 기존 사용자 처리
    #         return {"result": "Existing user", "user": {"id": user.id, "name": user.name, "login_type": user.login_type}}
    #     else:
    #         # 새 사용자 저장
    #         new_user = User(id=firebase_uid, name=name, login_type="google")
    #         session.add(new_user)
    #         session.commit()
    #         session.refresh(new_user)

    #         return {"result": "New user created", "user": {"id": new_user.id, "name": new_user.name, "login_type": new_user.login_type}}

    except firebase_auth.InvalidIdTokenError:
        raise HTTPException(status_code=401, detail="Invalid ID token")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unexpected error: {str(e)}")