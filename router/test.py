from database.model.user import User
from database.model.product import Product
from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db
from starlette.responses import JSONResponse
from datetime import datetime

router = APIRouter()


async def get_current_user(request: Request):
    """
    ✅ 미들웨어에서 검증된 사용자 정보 반환
    """
    if not hasattr(request.state, "user") or request.state.user is None:
        print("❌ `request.state.user`가 없음 (토큰이 검증되지 않았음)")
        raise HTTPException(status_code=401, detail="Unauthorized: Invalid token")

    print(f"✅ 요청한 사용자: {request.state.user['email']}")
    return request.state.user



# ✅ JWT 검증 후 전체 상품 리스트 반환
@router.get("/jwt-test", status_code=200)
async def get_all_products_with_jwt(
    session: Session = Depends(db.session), 
    current_user: dict = Depends(get_current_user)  # ✅ 토큰 검증된 사용자 정보 가져오기
):
    """
    ✅ JWT 인증이 필요한 API
    - 인증된 사용자만 모든 상품 리스트 조회 가능
    """
    products = session.query(Product).all()
    if not products:
        raise HTTPException(status_code=404, detail="No products found")

    return {
        "user": current_user["email"],  # ✅ 요청한 사용자의 이메일 포함
        "products": products
    }
