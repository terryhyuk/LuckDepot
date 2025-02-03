from database.model.order import Order
from database.model.product import Product
from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db
from starlette.responses import JSONResponse
from datetime import datetime
from database.model.deliver import Deliver
from database.model.orderdetail import OrderDetail
from sqlalchemy import func



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


    return product



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


@router.get('/test/{order_id}')
def user_deliver(session: Session = Depends(db.session), order_id: str = None):
    """
    배송현황 페이지
    orderid 입력해서 사용
    """
    try:
        delivers = session.query(
            Product.name, # 상품 이름
            Product.image,  # 상품 이미지
            OrderDetail.quantity,  # 상품별 구매 수량
            Deliver.id, # 배송 번호
            OrderDetail.id, # 주문 번호
            Order.status, # 배송 상태
            Order.order_date, # 주문날짜
            Order.address, # 배송지            
            Deliver.delivery_type, # Ship Mode
        ).join(
            Product,
            OrderDetail.product_id == Product.id
        ).join(
            Deliver,
            Deliver.order_id == OrderDetail.id
        ).join(
            Order,
            Order.id == OrderDetail.id
        ).filter(
            OrderDetail.id == order_id
        ).all()
        if not delivers:
            raise HTTPException(status_code=400, detail="deliverlist not found")
            
        return {'result': [
            {
                'product_name': deliver[0],
                'image': deliver[1], 
                'quantity': deliver[2],
                
            }
            for deliver in delivers
        ],
        'deliver_id': delivers[0][2],
        'order_id': delivers[0][4],
        'status': delivers[0][5],
        'order_date' : {
                        'month': int(delivers[0][6].strftime('%m')),
                        'year': int(delivers[0][6].strftime('%Y')),
                        },
        'weekday': (int(delivers[0][6].strftime('%w'))-1)%7,
        "address" : delivers[0][7],
        'delivery_type' : delivers[0][8]
        }
        
    except Exception as e:
        print('error', e)
        return {'result' : e}
    
